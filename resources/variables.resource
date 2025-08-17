*** Variables ***
${BASE_URL}             %{BASE_URL=https://points-app-backend.vercel.app}
${AUTH_RENEW_BEFORE}    %{AUTH_RENEW_BEFORE_SEC=60}
${EVIDENCE_DIR}         %{EVIDENCE_DIR=evidence}

# Usuário default para fluxos E2E (será gerado em runtime se vazio)
${DEFAULT_PASSWORD}     Senha@123
