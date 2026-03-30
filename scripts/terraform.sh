#!/usr/bin/env bash
# Run from repository root (this repo / freestar).
# Backend is declared in backend.tf (partial gcs); init supplies bucket/prefix via env or --backend-config FILE.
# Init runs first, then terraform workspace select (dev / prod — workspaces must exist).
# Plan/apply: pass multiple --var-file (e.g. common.tfvars then dev.tfvars); later files override.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

declare -a VAR_FILES=()

usage() {
  cat <<'EOF'
Usage: scripts/terraform.sh [options] <command>

Commands:
  fmt          terraform fmt -check -recursive
  init         terraform init -input=false
  workspace    terraform workspace select (requires init + --workspace)
  validate     terraform validate
  plan         terraform plan -input=false -out=tfplan
  apply        terraform apply -input=false tfplan
  all          fmt, init, workspace, validate, plan, apply

Backend init (one of):
  --backend-config FILE   HCL file with bucket, prefix, workspace_key_prefix
  Or set environment variables (same names as CI):
    TF_STATE_BUCKET                 (required)
    TF_STATE_PREFIX_BASE            optional, default freestar
    TF_WORKSPACE_KEY_PREFIX         optional, default env

Options:
  --workspace NAME        Terraform workspace (dev or prod)
  --var-file FILE         Repeat for each file; order matters (later overrides)

Examples:
  export TF_STATE_BUCKET=my-org-tf-state
  export TF_STATE_PREFIX_BASE=freestar
  export TF_WORKSPACE_KEY_PREFIX=env
  scripts/terraform.sh init
  scripts/terraform.sh validate --workspace dev
  scripts/terraform.sh plan --workspace dev \
    --var-file apps/example-api/common.tfvars \
    --var-file apps/example-api/dev.tfvars
  scripts/terraform.sh apply --workspace dev
EOF
  exit 1
}

BACKEND_CONFIG=""
WORKSPACE=""
CMD=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --backend-config)
      BACKEND_CONFIG="${2:?}"
      shift 2
      ;;
    --workspace)
      WORKSPACE="${2:?}"
      shift 2
      ;;
    --var-file)
      VAR_FILES+=("${2:?}")
      shift 2
      ;;
    fmt|init|workspace|validate|plan|apply|all)
      CMD="$1"
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      ;;
  esac
done

[[ -n "$CMD" ]] || usage

run_init() {
  if [[ -n "${BACKEND_CONFIG}" ]]; then
    [[ -f "$BACKEND_CONFIG" ]] || {
      echo "Backend config not found: $BACKEND_CONFIG" >&2
      exit 1
    }
    terraform init -input=false -backend-config="$BACKEND_CONFIG"
  elif [[ -n "${TF_STATE_BUCKET:-}" ]]; then
    local prefix="${TF_STATE_PREFIX_BASE:-freestar}"
    local wkp="${TF_WORKSPACE_KEY_PREFIX:-env}"
    terraform init -input=false \
      -backend-config="bucket=${TF_STATE_BUCKET}" \
      -backend-config="prefix=${prefix}" \
      -backend-config="workspace_key_prefix=${wkp}"
  else
    echo "Backend: set TF_STATE_BUCKET (and optional TF_STATE_PREFIX_BASE, TF_WORKSPACE_KEY_PREFIX) or pass --backend-config FILE" >&2
    exit 1
  fi
}

require_workspace() {
  [[ -n "${WORKSPACE:-}" ]] || {
    echo "This command requires --workspace (e.g. dev or prod)" >&2
    exit 1
  }
  terraform workspace select "$WORKSPACE"
}

case "$CMD" in
  fmt)
    terraform fmt -check -recursive
    ;;
  init)
    run_init
    ;;
  workspace)
    run_init
    require_workspace
    ;;
  validate)
    run_init
    require_workspace
    terraform validate
    ;;
  plan)
    run_init
    require_workspace
    [[ ${#VAR_FILES[@]} -gt 0 ]] || {
      echo "plan requires at least one --var-file (e.g. common + env)" >&2
      exit 1
    }
    for f in "${VAR_FILES[@]}"; do
      [[ -f "$f" ]] || {
        echo "Var file not found: $f" >&2
        exit 1
      }
    done
    plan_args=()
    for f in "${VAR_FILES[@]}"; do plan_args+=(-var-file="$f"); done
    terraform plan -input=false "${plan_args[@]}" -out=tfplan
    ;;
  apply)
    run_init
    require_workspace
    [[ -f tfplan ]] || {
      echo "tfplan not found; run plan first" >&2
      exit 1
    }
    terraform apply -input=false tfplan
    ;;
  all)
    terraform fmt -check -recursive
    run_init
    require_workspace
    [[ ${#VAR_FILES[@]} -gt 0 ]] || {
      echo "all requires at least one --var-file" >&2
      exit 1
    }
    for f in "${VAR_FILES[@]}"; do
      [[ -f "$f" ]] || {
        echo "Var file not found: $f" >&2
        exit 1
      }
    done
    terraform validate
    plan_args=()
    for f in "${VAR_FILES[@]}"; do plan_args+=(-var-file="$f"); done
    terraform plan -input=false "${plan_args[@]}" -out=tfplan
    terraform apply -input=false tfplan
    ;;
esac
