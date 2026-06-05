local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('sh', {

  -- Script header with strict mode
  s('sh-header', fmt([=[
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

{}
]=], { i(1) })),

  -- Logging helpers
  s('sh-log', fmt([=[
log()   { echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO  $*"; }
warn()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARN  $*" >&2; }
error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR $*" >&2; exit 1; }
]=], {})),

  -- Check required tools
  s('sh-require', fmt([=[
require() {
  for cmd in "$@"; do
    command -v "$cmd" &>/dev/null || error "Required tool not found: $cmd"
  done
}

require {}
]=], { i(1, 'kubectl terraform aws') })),

  -- Usage/help function
  s('sh-usage', fmt([=[
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

{}

Options:
  -h, --help    Show this help
  {}
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && usage && exit 0
]=], { i(1, 'Description of this script.'), i(2) })),

  -- Argument parsing
  s('sh-args', fmt([=[
while [[ $# -gt 0 ]]; do
  case "$1" in
    --{})
      {}="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      error "Unknown argument: $1"
      ;;
  esac
done
]=], { i(1, 'env'), i(2, 'ENV') })),

  -- Retry function
  s('sh-retry', fmt([=[
retry() {
  local retries={} delay={} cmd=("$@")
  for ((n=1; n<=retries; n++)); do
    "${cmd[@]}" && return 0
    [[ $n -lt $retries ]] && warn "Attempt $n/$retries failed, retrying in ${delay}s..." && sleep "$delay"
  done
  error "Command failed after $retries attempts: ${cmd[*]}"
}
]=], { i(1, '3'), i(2, '5') })),

  -- Cleanup trap
  s('sh-trap', fmt([=[
cleanup() {
  {}
}
trap cleanup EXIT INT TERM
]=], { i(1, 'echo "Cleaning up..."') })),

  -- if/else
  s('ifel', fmt([=[
if {}; then
  {}
else
  {}
fi
]=], { i(1, '[[ -n "$VAR" ]]'), i(2), i(3) })),

  -- for loop over array
  s('forin', fmt([=[
for {} in "${{}[@]}"; do
  {}
done
]=], { i(1, 'item'), i(2, 'items'), i(3) })),

  -- while read loop (process file/stdin line by line)
  s('whileread', fmt([=[
while IFS= read -r {}; do
  {}
done < {}
]=], { i(1, 'line'), i(2), i(3, '"$file"') })),

  -- Check if var is set
  s('sh-checkvar', fmt([=[
: "${{}:?'Variable {} must be set'}"
]=], { i(1, 'MY_VAR'), i(2, 'MY_VAR') })),

  -- Kubernetes helpers
  s('sh-k8s-wait', fmt([=[
wait_for_rollout() {
  local deployment="$1" namespace="${2:-default}"
  log "Waiting for rollout of $deployment in $namespace..."
  kubectl rollout status deployment/"$deployment" -n "$namespace" --timeout={}
}
]=], { i(1, '5m') })),

  -- AWS helpers
  s('sh-aws-profile', fmt([=[
export AWS_PROFILE={}
export AWS_DEFAULT_REGION={}
aws sts get-caller-identity &>/dev/null || error "AWS credentials not configured"
]=], { i(1, 'my-profile'), i(2, 'us-east-1') })),

  -- Terraform helpers
  s('sh-tf-deploy', fmt([=[
tf_deploy() {
  local env="$1" dir="${2:-.}"
  log "Deploying Terraform for env: $env"
  terraform -chdir="$dir" init -reconfigure
  terraform -chdir="$dir" plan -var-file="envs/$env.tfvars" -out=tfplan
  terraform -chdir="$dir" apply -auto-approve tfplan
}
]=], {})),

  -- Docker helpers
  s('sh-docker-build', fmt([=[
IMAGE={}
TAG=${GITHUB_SHA:-$(git rev-parse --short HEAD)}

docker build -t "$IMAGE:$TAG" -t "$IMAGE:latest" .
docker push "$IMAGE:$TAG"
docker push "$IMAGE:latest"
]=], { i(1, 'my-registry/my-image') })),

  -- Temp dir with cleanup
  s('sh-tmpdir', fmt([=[
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
]=], {})),

})
