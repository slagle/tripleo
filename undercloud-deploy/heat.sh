$!/bin/bash
heat --os-username admin --os-password fake --os-auth-url http://127.0.0.1:35358/v3 --os-project-id admin $@
