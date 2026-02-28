# mistral-vibe 2.2.1 has strict version pins that lag behind nixpkgs
# Issue: pythonRuntimeDepsCheck fails with multiple version mismatches:
#   - cryptography<=46.0.3,>=44.0.0 not satisfied by version 46.0.4
#   - agent-client-protocol==0.8.0 not satisfied by version 0.8.1
#   - mistralai==1.9.11 not satisfied by version 1.12.2
# Workaround: Use pythonRelaxDeps = true to loosen all version constraints
# Status: temporary - upstream mistral-vibe should relax its pins
# Last checked: 2025-07-27
# Remove after: mistral-vibe relaxes its dependency version constraints
_final: prev: {
  mistral-vibe = prev.mistral-vibe.overridePythonAttrs (_oldAttrs: {
    pythonRelaxDeps = true;
  });
}
