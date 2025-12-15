# Ferramenta Profissional de Manutenção do Windows

🛠️ Uma ferramenta completa e interativa em script Batch (.bat) para resolver problemas comuns e otimizar o Windows 10/11 de forma simples e segura.

Ideal para usuários avançados, técnicos de informática e quem quer manter o PC rápido e estável sem instalar programas extras. Tudo usando comandos nativos do Windows!

## Funcionalidades principais
- **Menu interativo** fácil de usar
- **Limpeza completa**: Arquivos temporários, Prefetch, Temp e Limpeza de Disco
- **Correção do sistema**: SFC /scannow + DISM /RestoreHealth
- **Verificação de disco**: Agendamento de CHKDSK (/f /r)
- **Otimização automática**: Detecção de SSD/HDD (TRIM ou desfragmentação), reset de Winsock/IP e mais
- **Manutenção total**: Executa tudo de uma vez com criação de ponto de restauração
- **Criação de ponto de restauração** do sistema
- **Logs detalhados** em C:\ManutencaoLogs para acompanhamento
- **Informações do sistema** rápidas
- Verificação automática de execução como Administrador

## Como usar
1. Baixe o arquivo `.bat` principal (ex: `Manutencao_Windows.bat`)
2. Clique com o botão direito → "Executar como administrador"
3. Escolha a opção no menu e siga as instruções

**Atenção**: Sempre crie um ponto de restauração antes de manutenções pesadas. O script já oferece essa opção!

## Requisitos
- Windows 10 ou 11
- Executar como Administrador (o script verifica isso automaticamente)

## Avisos importantes
- Use com responsabilidade: comandos como CHKDSK podem exigir reinicialização e demorar.
- Testado em ambientes limpos – faça backup se necessário.
- Não é um substituto para antivírus ou atualizações oficiais do Windows.

## Contribuições
Sinta-se à vontade para abrir issues ou pull requests com melhorias, correções ou novas funcionalidades!

Licença: MIT (livre para uso, modificação e distribuição)

Feito com 💻 por [seu nome/usuário] – Ajude a manter o Windows dos brasileiros rodando liso! 🚀
