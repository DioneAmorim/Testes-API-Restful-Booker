# Projeto de Testes API - Restful-Booker

Estrutura inicial criada para executar testes Robot Framework contra a API Restful-Booker.

Requisitos

Instale dependências:

```bash
pip install -r requirements.txt
```

Executar os testes:

```bash
robot tests/funcional/api
```

Executar via script Python:

```bash
python run_api_tests.py --suite all
python run_api_tests.py --suite performance
python run_api_tests.py --suite security
```

Arquivos principais adicionados/atualizados:

- resources/keywords/api_keywords.resource  (keywords de sessão API, booking, performance e segurança)
- tests/funcional/api/auth/auth_suites.robot (corrigido e apontando para resources)
- tests/funcional/api/booking/booking_suites.robot (CRUD e validações de booking)
- tests/funcional/api/performance/performance_suites.robot (testes de performance)
- tests/funcional/api/security/security_suites.robot (testes de segurança)
- run_api_tests.py (script de automação para execução)
