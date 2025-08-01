#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "🔑 Generating token for 'admin' service account..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed!"
    exit 1
fi

TOKEN=$(kubectl -n kubernetes-dashboard create token admin)

echo "✅ Token generated successfully:"
echo ""
echo "------------------------------------------------------------------"
echo "${TOKEN}"
echo "------------------------------------------------------------------"
echo ""
echo "📋 Copy the token above and paste it into the dashboard login page."
