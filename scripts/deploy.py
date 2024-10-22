import os
import subprocess
import shutil
from datetime import datetime

# Caminho base do projeto (diretório raiz do addon)
base_path = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

# Caminho do diretório onde o deploy.py está localizado
scripts_path = os.path.dirname(os.path.realpath(__file__))

# Listas de arquivos e pastas a serem excluídos do deploy
exclude_files = ["deploy.py", "dev_notes.md", "*.drawio", ".gitignore"]  # Arquivos que não devem ser copiados
exclude_dirs = [".git","Z-archive", "templates", "scripts"]  # Pastas que não devem ser copiadas

# Função para obter a branch atual via Git, no diretório do addon
def get_current_branch():
    result = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=base_path  # Garante que a branch é lida no repositório do addon
    )
    if result.returncode != 0:
        print(f"Erro ao determinar a branch atual: {result.stderr.decode('utf-8').strip()}")
        return "unknown"
    return result.stdout.decode('utf-8').strip()

# Função para obter a data e hora atual formatada
def get_current_timestamp():
    return datetime.now().strftime("%d.%m.%Y - %H:%M:%S")

# Função para ler informações do addon do arquivo core/core_init.lua
def get_addon_info():
    core_init_path = os.path.join(base_path, "modules", "core", "core_init.lua")
    addon_version = "unknown"
    addon_external_name = "unknown"
    if os.path.exists(core_init_path):
        with open(core_init_path, 'r', encoding='utf-8') as file:
            for line in file:
                if "_G[\"addonVersion\"]" in line:
                    addon_version = line.split('=')[1].strip().replace('"', '')
                elif "_G[\"addonExternalName\"]" in line:
                    addon_external_name = line.split('=')[1].strip().replace('"', '')
    else:
        print(f"Aviso: Arquivo {core_init_path} não encontrado.")
    return addon_version, addon_external_name

# Função para buscar informações dos componentes dos arquivos _init.lua, snippets, e handlers
def get_components_info():
    components = {
        "modules": [],
        "snippets": [],
        "handlers": []
    }
    
    # Definir os caminhos para cada tipo de componente
    component_paths = {
        "modules": os.path.join(base_path, "modules"),
        "snippets": os.path.join(base_path, "snippets"),
        "handlers": os.path.join(base_path, "handlers")
    }
    
    for component_type, path in component_paths.items():
        if os.path.exists(path):
            for root, _, files in os.walk(path):
                for file in files:
                    # Para módulos, considerar apenas arquivos _init.lua
                    if component_type == "modules" and not file.endswith("_init.lua"):
                        continue
                    if component_type in ["snippets", "handlers"] and not file.endswith(".lua"):
                        continue

                    component_path = os.path.join(root, file)
                    component_name = "unknown"
                    component_version = "unknown"
                    component_external_name = "unknown"
                    component_type_var = "unknown"
                    with open(component_path, 'r', encoding='utf-8') as f:
                        for line in f:
                            if "local componentExternalName" in line:
                                component_external_name = line.split('=')[1].strip().replace('"', '')
                            elif "local componentVersion" in line:
                                component_version = line.split('=')[1].strip().replace('"', '')
                            elif "local componentName" in line:
                                component_name = line.split('=')[1].strip().replace('"', '')
                            elif "local componentType" in line:
                                component_type_var = line.split('=')[1].strip().replace('"', '')
                    components[component_type].append({
                        "name": component_name,
                        "external_name": component_external_name,
                        "version": component_version,
                        "type": component_type_var
                    })
    return components

# Função para atualizar o arquivo core/core_init.lua com branch e timestamp
def update_main_init(branch, timestamp):
    main_init_path = os.path.join(base_path, "modules", "core", "core_init.lua")
    if os.path.exists(main_init_path):
        # Ler o conteúdo do arquivo com codificação UTF-8
        with open(main_init_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        # Atualizar as linhas de branch e timestamp
        with open(main_init_path, 'w', encoding='utf-8') as file:  # Certifica que a gravação será em UTF-8
            for line in lines:
                if "_G[\"addonBranch\"]" in line:
                    file.write(f'_G["addonBranch"] = "{branch}"\n')
                elif "_G[\"latestDeploy\"]" in line:
                    file.write(f'_G["latestDeploy"] = "{timestamp}"\n')
                else:
                    file.write(line)
        print(f"Updated core/core_init.lua with branch '{branch}' and timestamp '{timestamp}'.")
    else:
        print(f"Erro: Arquivo {main_init_path} não encontrado para atualizar.")

# Função para atualizar o arquivo .toc com a versão do addon
def update_toc_version(addon_version):
    toc_path = os.path.join(base_path, "AuctionHouseProTools.toc")
    if os.path.exists(toc_path):
        with open(toc_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        with open(toc_path, 'w', encoding='utf-8') as file:
            for line in lines:
                if line.startswith("## Version:"):
                    file.write(f'## Version: {addon_version}\n')
                else:
                    file.write(line)
        print(f"Updated {toc_path} with version '{addon_version}'.")
    else:
        print(f"Erro: Arquivo {toc_path} não encontrado para atualizar.")

# Função para construir o comando de exclusão para o robocopy
def build_robocopy_exclusions():
    exclusion_params = []
    for file in exclude_files:
        exclusion_params.append("/XF")
        exclusion_params.append(file)
    for directory in exclude_dirs:
        exclusion_params.append("/XD")
        exclusion_params.append(directory)
    return exclusion_params

# Função para limpar a pasta do WoW usando robocopy
def clean_wow_addon_folder(wow_addon_path):
    # Criar uma pasta temporária vazia
    empty_temp_dir = os.path.join(base_path, "temp_empty")
    if not os.path.exists(empty_temp_dir):
        os.makedirs(empty_temp_dir)
    
    # Usar robocopy para sincronizar e deletar tudo da pasta do addon
    robocopy_command = ["robocopy", empty_temp_dir, wow_addon_path, "/MIR"]
    result = subprocess.run(robocopy_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
    if result.returncode >= 8:
        print(f"Erro durante a execução do robocopy para limpar a pasta: {result.stderr.decode('latin-1')}")
    else:
        print(f"Cleaned addon folder: {wow_addon_path}")
    
    # Excluir a pasta temporária após o processo de limpeza
    try:
        shutil.rmtree(empty_temp_dir)
        print(f"Temporary folder '{empty_temp_dir}' removed.")
    except PermissionError as e:
        print(f"Failed to remove '{empty_temp_dir}': {e}")

# Função para copiar e substituir os arquivos para a pasta do jogo e listar os arquivos copiados
def deploy_to_wow():
    wow_addon_path = "C:\\Program Files (x86)\\World of Warcraft\\_retail_\\Interface\\AddOns\\AuctionHouseProTools"
    
    # Limpar a pasta do WoW AddOn antes de copiar novos arquivos
    clean_wow_addon_folder(wow_addon_path)
    
    # Adicionar parâmetros de exclusão ao robocopy
    exclusion_params = build_robocopy_exclusions()
    
    # Usar robocopy para substituir arquivos e copiar todos, incluindo subpastas, com exclusões
    robocopy_command = ["robocopy", base_path, wow_addon_path, "/MIR"] + exclusion_params
    result = subprocess.run(robocopy_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
    if result.returncode >= 8:
        print(f"Erro durante a execução do robocopy: {result.stderr.decode('latin-1')}\nSaída completa: {result.stdout.decode('latin-1')}")
    else:
        # Listar os arquivos copiados
        output = result.stdout.decode('latin-1')
        print("Arquivos copiados:")
        for line in output.splitlines():
            if "New File" in line or "New Dir" in line:
                print(line)
        print(f"Files copied and replaced in {wow_addon_path}, with exclusions applied.")

# Identificar a branch atual e o timestamp
branch = get_current_branch()
timestamp = get_current_timestamp()

# Atualizar o arquivo core_init.lua principal
update_main_init(branch, timestamp)

# Obter informações do addon
addon_version, addon_external_name = get_addon_info()

# Obter informações dos componentes
components_info = get_components_info()

# Exibir informações do addon
print("-- Addon --")
print(f"{addon_external_name} - Version: {addon_version}")

# Exibir informações dos componentes
print("\n-- Components --")
for component_type, components in components_info.items():
    if components:
        print(f"{component_type.capitalize()}:")
        for component in components:
            print(f"{component['external_name']} - Version: {component['version']} - Type: {component['type']}")
    else:
        print(f"\n{component_type.capitalize()}: No components found.")

# Atualizar o arquivo .toc com a versão do addon
update_toc_version(addon_version)
# Atualizar o arquivo .toc com a versão do addon
print(f"\nUpdated {os.path.join(base_path, 'AuctionHouseProTools.toc')} with version '{addon_version}'.")

# Copiar arquivos para a pasta do WoW
deploy_to_wow()

# Executar script de relatório após o deploy
report_script_path = os.path.join(scripts_path, "addon_code_report_generator.py")
subprocess.run(["python", report_script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

print("Deploy completed successfully!")
