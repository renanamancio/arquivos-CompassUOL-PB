### Configuração do Ambiente

- **Limpar Variáveis Globais:** Antes de iniciar os testes, apague todas as variáveis globais, mantendo apenas a `baseURL`.
    
- **Autenticação:** Caso a autenticação falhe, limpe as variáveis globais relacionadas ao token e execute novamente a coleção "Logar Usuário".
    

### Execução das Coleções

Execute as coleções na seguinte ordem:

1. **Coleção "Massa de Dados de Usuários"**
    
    - Utilize o Collection Runner.
        
2. **Coleção "Capturar Informações de Usuários"**
    
    - Utilize o Collection Runner.
        
3. **Coleção "Logar Usuário"**
    
    - Utilize o Collection Runner.
        
4. **Coleção "Massa de Dados de Produtos"**
    
    - **Ponto de Atenção:** Execute uma requisição por vez, pois o Collection Runner está apresentando problemas de autenticação.
        
5. **Coleção "Capturar informações de Produtos"**
    
    - Utilize o Collection Runner.
        
6. **Coleção "Cadastro de Carrinhos"**
    
    - **Ponto de Atenção:** Execute uma requisição por vez, pois o Collection Runner está apresentando problemas de autenticação.
        

---

## Estrutura da Sessão de Teste

Para garantir a ordem correta, siga esta sequência de módulos durante a sessão de testes:

- Módulo de Usuários
    
- Módulo de Login
    
- Módulo de Produtos
    
- Módulo de Carrinho