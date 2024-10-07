import os
import subprocess
import shutil
from datetime import datetime

# Caminho base (diretório onde o deploy.py está localizado)
base_path = os.path.dirname(os.path.realpath(__file__))

# Lista de arquivos/pastas a serem excluídos do deploy
exclude_files = ["deploy.py", "dev_notes.md", "*.drawio","*.git","*.gitignore"]  # Adicione aqui os arquivos que não devem ser copiados

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

# Função para atualizar o arquivo Core/init.lua com branch e timestamp
def update_main_init(branch, timestamp):
    main_init_path = os.path.join(base_path, "Core", "init.lua")
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
    print(f"Updated Core/init.lua with branch '{branch}' and timestamp '{timestamp}'.")

# Função para construir o comando de exclusão para o robocopy
def build_robocopy_exclusions():
    exclusion_params = []
    for file in exclude_files:
        exclusion_params.append("/XF")  # Parâmetro de exclusão de arquivos do robocopy
        exclusion_params.append(file)
    return exclusion_params

# Função de callback para lidar com problemas de permissão na exclusão
def on_rm_error(func, path, exc_info):
    # Verifica se a permissão de acesso foi negada e tenta novamente com permissão extra
    os.chmod(path, 0o777)  # Tenta dar permissão total
    func(path)

# Função para limpar a pasta do WoW usando robocopy
def clean_wow_addon_folder(wow_addon_path):
    # Criar uma pasta temporária vazia
    empty_temp_dir = os.path.join(base_path, "temp_empty")
    if not os.path.exists(empty_temp_dir):
        os.makedirs(empty_temp_dir)
    
    # Usar robocopy para sincronizar e deletar tudo da pasta do addon
    robocopy_command = ["robocopy", empty_temp_dir, wow_addon_path, "/MIR"]
    subprocess.run(robocopy_command, stdout=subprocess.PIPE)
    
    print(f"Cleaned addon folder: {wow_addon_path}")
    
    # Excluir a pasta temporária após o processo de limpeza
    try:
        shutil.rmtree(empty_temp_dir, onerror=on_rm_error)
        print(f"Temporary folder '{empty_temp_dir}' removed.")
    except PermissionError as e:
        print(f"Failed to remove '{empty_temp_dir}': {e}")

# Função para copiar e substituir os arquivos para a pasta do jogo
def deploy_to_wow():
    wow_addon_path = "C:\\Program Files (x86)\\World of Warcraft\\_retail_\\Interface\\AddOns\\Auction-House-Pro-Tools"
    
    # Limpar a pasta do WoW AddOn antes de copiar novos arquivos
    clean_wow_addon_folder(wow_addon_path)
    
    # Adicionar parâmetros de exclusão ao robocopy
    exclusion_params = build_robocopy_exclusions()
    
    # Usar robocopy para substituir arquivos e copiar todos, incluindo subpastas, com exclusões
    robocopy_command = ["robocopy", base_path, wow_addon_path, "/MIR"] + exclusion_params
    subprocess.run(robocopy_command, stdout=subprocess.PIPE)
    
    print(f"Files copied and replaced in {wow_addon_path}, with exclusions applied.")

# Configurações dos módulos
modules = [
    {"name": "Core", "path": "Core"},
    {"name": "Control Panel", "path": "Control_panel"},
#    {"name": "Sales Summary Extended", "path": "Sales_summary_extended"},
#    {"name": "Undercut Wars Helper", "path": "Undercut_wars_helper"},
    {"name": "Log Tester 01", "path": "Log_tester_01"},
    {"name": "Log Tester 02", "path": "Log_tester_02"},
    
]

# Identificar a branch atual e o timestamp
branch = get_current_branch()
timestamp = get_current_timestamp()

# Atualizar o arquivo init.lua principal
update_main_init(branch, timestamp)

# Exibir a versão de cada módulo
for module in modules:
    version = get_module_version(module["path"])
    print(f"{module['name']} - Version: {version}")

# Copiar arquivos para a pasta do WoW
deploy_to_wow()

print("Deploy completed successfully!")