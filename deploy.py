import os
import subprocess
from datetime import datetime

# Caminho base (diretório onde o deploy.py está localizado)
base_path = os.path.dirname(os.path.realpath(__file__))

# Função para obter a branch atual via Git, no diretório do addon
def get_current_branch():
    result = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        stdout=subprocess.PIPE,
        cwd=base_path  # Garante que a branch é lida no repositório do addon
    )
    return result.stdout.decode('utf-8').strip()

# Função para obter a data e hora atual formatada
def get_current_timestamp():
    return datetime.now().strftime("%d.%m.%Y - %H:%M:%S")

# Função para ler a versão de cada módulo diretamente do arquivo init.lua (com codificação UTF-8)
def get_module_version(module_path):
    init_file_path = os.path.join(base_path, module_path, "init.lua")
    with open(init_file_path, 'r', encoding='utf-8') as file:  # Codificação UTF-8
        lines = file.readlines()
    
    for line in lines:
        if "local moduleVersion" in line:
            # Extrair a versão
            version = line.split('=')[1].strip().replace('"', '')
            return version
    return "unknown"

# Função para atualizar o arquivo init.lua principal com a branch e timestamp
def update_main_init(branch, timestamp):
    main_init_path = os.path.join(base_path, "init.lua")
    
    # Ler o conteúdo do arquivo com codificação UTF-8
    with open(main_init_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    
    # Atualizar as linhas de branch e timestamp
    with open(main_init_path, 'w', encoding='utf-8') as file:  # Certifica que a gravação será em UTF-8
        for line in lines:
            if "local addonBranch" in line:
                file.write(f'local addonBranch = "{branch}"\n')
            elif "local latestDeploy" in line:
                file.write(f'local latestDeploy = "{timestamp}"\n')
            else:
                file.write(line)
    
    print(f"Updated main init.lua with branch '{branch}' and timestamp '{timestamp}'.")

# Função para copiar e substituir os arquivos para a pasta do jogo
def deploy_to_wow():
    wow_addon_path = "C:\\Program Files (x86)\\World of Warcraft\\_retail_\\Interface\\AddOns\\Auction-House-Pro-Tools"
    
    # Se a pasta do WoW AddOn não existir, criar
    if not os.path.exists(wow_addon_path):
        os.makedirs(wow_addon_path)
        print(f"Created directory: {wow_addon_path}")
    
    # Usar robocopy para substituir arquivos e copiar todos, incluindo subpastas
    subprocess.run(["robocopy", base_path, wow_addon_path, "/MIR"], stdout=subprocess.PIPE)  # /MIR para espelhar e substituir arquivos
    print(f"Files copied and replaced in {wow_addon_path}")

# Configurações dos módulos
modules = [
    {"name": "Control Panel", "path": "control_panel"},
    {"name": "Module 01", "path": "module_01"},
    {"name": "Module 02", "path": "module_02"},
]

# Identificar a branch atual e o timestamp
branch = get_current_branch()
timestamp = get_current_timestamp()

# Atualizar o arquivo init.lua principal
update_main_init(branch, timestamp)

# Exibir a versão de cada módulo
for module in modules:
    version = get_module_version(module["path"])
    print(f"{module['name']} Version: {version}")

# Copiar arquivos para a pasta do WoW
deploy_to_wow()

print("Deploy completed successfully!")