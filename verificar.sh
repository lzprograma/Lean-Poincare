#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
command -v elan >/dev/null || curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y --default-toolchain none
export PATH="$HOME/.elan/bin:$PATH"
elan toolchain install "$(cat lean-toolchain)"
lake exe cache get
lake build PoincareLib PoincareConjecture
lake build Challenge Solution @Comparator/comparator @lean4export/lean4export
cat > /tmp/axioms_check.lean <<'LEAN'
import PoincareConjecture
#print axioms PoincareConjecture.smoothPoincareSkeleton
#print axioms PoincareConjecture.topologicalPoincareSkeleton
LEAN
lake env lean /tmp/axioms_check.lean
