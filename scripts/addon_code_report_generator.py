import os
from datetime import datetime

def generate_directory_tree(startpath, prefix=''):
    """
    Função recursiva para gerar uma árvore de diretórios e arquivos.
    """
    result = []
    files = sorted(os.listdir(startpath))  # Lista de arquivos e pastas ordenados
    for index, name in enumerate(files):
        filepath = os.path.join(startpath, name)
        connector = '└── ' if index == len(files) - 1 else '├── '
        result.append(f"{prefix}{connector}{name}")

        if os.path.isdir(filepath):
            # Adiciona recursivamente o conteúdo da subpasta
            extension = '    ' if index == len(files) - 1 else '│   '
            result.extend(generate_directory_tree(filepath, prefix + extension))
    
    return result

def get_addon_info(addon_folder):
    core_init_path = os.path.join(addon_folder, "modules", "core", "core_init.lua")
    addon_version = "unknown"
    addon_external_name = "unknown"
    if os.path.exists(core_init_path):
        with open(core_init_path, 'r', encoding='utf-8') as file:
            for line in file:
                if "_G[\"addonVersion\"]" in line:
                    addon_version = line.split('=')[1].strip().replace('"', '')
                elif "_G[\"addonExternalName\"]" in line:
                    addon_external_name = line.split('=')[1].strip().replace('"', '')
    return addon_external_name, addon_version

def get_components_info(addon_folder):
    components = {
        "modules": [],
        "snippets": [],
        "handlers": []
    }
    
    # Definir os caminhos para cada tipo de componente
    component_paths = {
        "modules": os.path.join(addon_folder, "modules"),
        "snippets": os.path.join(addon_folder, "snippets"),
        "handlers": os.path.join(addon_folder, "handlers")
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

def generate_addon_report(addon_folder, output_file, file_exclusions=None, folder_exclusions=None):
    # Cabeçalho explicativo
    current_time = datetime.now().strftime("%d/%m/%Y - %H:%M:%S")
    header = (
        "=== Auction House Pro Tools Addon Source Code Report ===\n"
        "\n"
        f"Code report generated at: {current_time}\n"
        "\n"
        "DISCLAIMER: This report contains the source code of the Auction House Pro Tools addon for World of Warcraft.\n"
        "Each section below corresponds to a specific file, and the content is organized by filename.\n"
        "Files and folders listed under exclusions are not included in this report.\n"
        "Use this information to contextualize about the updated status project code\n"
        "Please disregard any previous versions of the addon code that were in memory.\n"
        "From now on, this is the definitive code we will work with until the next update. We will continue our progress based solely on this version of the code.\n"
        "Please review the code to understand the current state of the addon.\n\n"
    )
    
    # Abre o arquivo de saída e mantém aberto até o final do processo
    with open(output_file, 'w', encoding='utf-8') as outfile:
        # Escreve o cabeçalho explicativo
        outfile.write(header)

        # Adiciona informações do addon
        outfile.write("-----------------------------------------------\n")
        outfile.write("\n=== Updated Addon components informations ===\n")
        outfile.write("Here the updated addon details, with all components and versions\n\n")
        addon_external_name, addon_version = get_addon_info(addon_folder)
        outfile.write("-- Addon --")
        outfile.write(f"\n{addon_external_name} - Version: {addon_version}\n\n")

        # Adiciona informações dos componentes
        components_info = get_components_info(addon_folder)
        outfile.write("-- Components --")
        for component_type, components in components_info.items():
            if components:
                outfile.write(f"\n{component_type.capitalize()}:\n")
                for component in components:
                    outfile.write(f"{component['external_name']} - Version: {component['version']} - Type: {component['type']}\n")
            else:
                outfile.write(f"\n{component_type.capitalize()}: No components found.\n")

        # Adiciona a estrutura de diretórios e arquivos no formato de árvore
        outfile.write("-----------------------------------------------\n")
        outfile.write("\n=== Updated directory structure ===\n")
        directory_tree = generate_directory_tree(addon_folder)
        for line in directory_tree:
            outfile.write(line + "\n")

        if file_exclusions is None:
            file_exclusions = []
        if folder_exclusions is None:
            folder_exclusions = []

        # Função para verificar se o arquivo deve ser ignorado
        def is_file_excluded(file_name):
            return any(exc in file_name for exc in file_exclusions)

        # Função para verificar se a pasta deve ser ignorada
        def is_folder_excluded(folder_path):
            return any(folder_path.startswith(os.path.join(addon_folder, exc)) for exc in folder_exclusions)

        # Caminha pelos diretórios e arquivos dentro da pasta do addon
        for root, dirs, files in os.walk(addon_folder):
            # Se o diretório atual está na lista de exclusões, pula ele e seus subdiretórios
            if is_folder_excluded(root):
                continue

            for file in files:
                if not is_file_excluded(file):
                    file_path = os.path.join(root, file)
                    with open(file_path, 'r', encoding='utf-8') as f:
                        file_content = f.read()

                    # Adiciona o conteúdo no arquivo de saída
                    outfile.write(f"=== File: {file_path} ===\n\n")
                    outfile.write(file_content + "\n")
                    outfile.write(f"=== End of {file_path} ===\n\n")

if __name__ == "__main__":
    # Parâmetros do script
    addon_folder = r"C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\AuctionHouseProTools"
    output_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), "AuctionHouseProTools-addon_code_report.txt")
    file_exclusions = ['README.md','LICENSE', '.txt']  # Excluir arquivos específicos
    folder_exclusions = ['Templates']  # Excluir pastas específicas (com subpastas)

    # Gera o relatório
    generate_addon_report(addon_folder, output_file, file_exclusions, folder_exclusions)
