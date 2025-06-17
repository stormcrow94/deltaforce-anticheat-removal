# Delta Force Anti-Cheat Removal

Script PowerShell avançado para remoção completa de resquícios do anti-cheat do Delta Force e outros anti-cheats comuns (BattlEye, EasyAntiCheat, Riot Vanguard).

## ⚠️ Aviso Importante

- **Execute sempre como Administrador**
- Faça um ponto de restauração antes de usar
- Use por sua conta e risco
- Este script é para uso legítimo após desinstalação de jogos

## 🚀 Como Usar

### Instalação e Execução

1. **Baixe o script**
   ```powershell
   git clone https://github.com/[seu-usuario]/deltaforce-anticheat-removal.git
   cd deltaforce-anticheat-removal
   ```

2. **Abra o PowerShell como Administrador**
   - Pressione `Win + X`
   - Selecione "Windows PowerShell (Admin)" ou "Terminal (Admin)"

3. **Execute o comando para permitir scripts**
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```

4. **Execute o script**
   ```powershell
   .\remover-anticheat-avancado.ps1
   ```

5. **Reinicie o computador após conclusão**

## 🎯 O que é removido

### Serviços
- BEService (BattlEye)
- EasyAntiCheat
- vgc (Riot Vanguard)
- vgk (Riot Vanguard Kernel)

### Drivers do Sistema
- `%WINDIR%\System32\drivers\BEDaisy.sys`
- `%WINDIR%\System32\drivers\EasyAntiCheat.sys`
- `%WINDIR%\System32\drivers\vgc.sys`
- `%WINDIR%\System32\drivers\vgk.sys`

### Diretórios
- `%ProgramData%\BattlEye`
- `%ProgramData%\EasyAntiCheat`
- `%ProgramData%\Riot Vanguard`
- `%ProgramFiles%\BattlEye`
- `%ProgramFiles%\EasyAntiCheat`
- `%ProgramFiles%\Riot Vanguard`
- `%ProgramFiles(x86)%\BattlEye`
- `%ProgramFiles(x86)%\EasyAntiCheat`
- `%LocalAppData%\BattlEye`
- `%LocalAppData%\EasyAntiCheat`
- `%AppData%\EasyAntiCheat`

### Chaves do Registro
- `HKLM\SYSTEM\CurrentControlSet\Services\[AntiCheat]`
- `HKLM\SOFTWARE\[AntiCheat]`
- `HKLM\SOFTWARE\Wow6432Node\[AntiCheat]`
- `HKCU\SOFTWARE\[AntiCheat]`

### Processos e Arquivos Temporários
- Processos em execução relacionados
- Arquivos temporários com padrões: `*battleye*`, `*easyanticheat*`, `*eac*`, `*vanguard*`

## 📋 Recursos do Script

- ✅ Verificação automática de privilégios de administrador
- ✅ Parada e remoção de serviços
- ✅ Exclusão de drivers do kernel
- ✅ Limpeza profunda de diretórios
- ✅ Remoção de entradas do registro
- ✅ Encerramento de processos em execução
- ✅ Limpeza de arquivos temporários
- ✅ Verificação final e relatório de status
- ✅ Interface colorida e informativa

## 🛠️ Solução de Problemas

### Erro: "não pode ser carregado porque a execução de scripts foi desabilitada"
Execute este comando primeiro:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### Erro: "Acesso Negado"
- Certifique-se de estar executando como Administrador
- Feche todos os jogos e launchers
- Tente reiniciar em Modo de Segurança

### Arquivos não podem ser deletados
1. Reinicie o computador
2. Execute o script novamente
3. Se persistir, use o Modo de Segurança:
   - `Win + R` → `msconfig`
   - Aba "Inicialização" → Marque "Inicialização segura"
   - Reinicie e execute o script

### Serviço ainda aparece após remoção
O script informará quais serviços não puderam ser removidos. Neste caso:
1. Reinicie em Modo de Segurança
2. Execute o script novamente
3. Ou use: `sc delete [NomeDoServico]` manualmente

## 🔍 Verificação Pós-Limpeza

Após executar o script, verifique:

1. **Serviços**: 
   ```powershell
   Get-Service | Where-Object {$_.Name -match "BEService|EasyAntiCheat|vgc|vgk"}
   ```

2. **Drivers**:
   ```powershell
   Get-ChildItem "$env:WINDIR\System32\drivers" | Where-Object {$_.Name -match "BEDaisy|EasyAntiCheat|vgc|vgk"}
   ```

3. **Processos**:
   ```powershell
   Get-Process | Where-Object {$_.ProcessName -match "BEService|EasyAntiCheat|vgtray|vgc|vgk"}
   ```

4. **Integridade do Sistema**:
   ```powershell
   sfc /scannow
   ```

## 📊 Exemplo de Saída

```
========================================
  REMOVEDOR AVANÇADO DE ANTI-CHEAT
========================================

[1/7] Removendo serviços...
Parando serviço: BEService
Removendo serviço: BEService

[2/7] Removendo drivers...
Removendo driver: BEDaisy.sys

[3/7] Removendo diretórios do sistema...
Removendo: C:\ProgramData\BattlEye

[4/7] Limpando entradas do registro...
Removendo chave: HKLM:\SYSTEM\CurrentControlSet\Services\BEService

[5/7] Verificando processos em execução...
Encerrando processo: BEService

[6/7] Limpando arquivos temporários...

[7/7] Realizando verificação final...

========================================
  LIMPEZA CONCLUÍDA!
========================================
```

## 📝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs via Issues
- Sugerir melhorias
- Adicionar suporte para outros anti-cheats
- Melhorar a documentação

## ⚖️ Licença

Este projeto é distribuído sob a licença MIT. Use por sua conta e risco.

## 🤝 Suporte

Se encontrar problemas:
1. Verifique a seção de Solução de Problemas acima
2. Abra uma issue no GitHub com:
   - Versão do Windows
   - Mensagem de erro completa
   - Screenshot se possível
   - Quais anti-cheats estavam instalados

---

**Nota Legal**: Este script é destinado apenas para limpeza legítima após desinstalação de jogos. Não use para contornar sistemas anti-cheat ativos ou para propósitos maliciosos.
