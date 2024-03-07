import pandas as pd
import numpy as np
import os

def replace_text(original_text, replace_df, search_col, replace_col, replace_type):
    try:
    # Busca los índices del texto original en la columna de búsqueda
        original = replace_df[search_col].tolist()

        for value in original:
            replacement = replace_df[replace_df[search_col] == value][replace_col].values[0]
            if (replacement == ""):
                continue
            original_text = original_text.replace(value, replacement)
            
        return original_text  # Devuelve el texto original si no se encuentra ninguna coincidencia
    except:
        return original_text

# Carga el archivo Excel
file_path = "excel.xlsm"
mail_df = pd.read_excel(file_path, sheet_name="MAIL")
replace_df = pd.read_excel(file_path, sheet_name="REPLACES")
replace_df = replace_df.replace(np.nan, '', regex=True)

# Crea las nuevas columnas MCUERPO1_AGILICE y MCUERPO1_REDMAT
mail_df['MCUERPO1_AGILICE'] = mail_df['MCUERPO1']
mail_df['MCUERPO1_REDMAT'] = mail_df['MCUERPO1']

# Aplica la función replace_text a la columna MCUERPO1 para llenar las nuevas columnas
mail_df['MCUERPO1_AGILICE'] = mail_df['MCUERPO1'].apply(lambda x: replace_text(x, replace_df, "ORIGINAL", "REEMPLAZO AGILICE", "AGILICE"))
mail_df['MCUERPO1_REDMAT'] = mail_df['MCUERPO1'].apply(lambda x: replace_text(x, replace_df, "ORIGINAL", "REEMPLAZO REDMAT", "REDMAT"))

# Guarda el DataFrame actualizado en un nuevo archivo Excel
output_file_path = "excel_output.xlsx"
mail_df.to_excel(output_file_path, index=False)
print("Archivo Excel actualizado guardado en:", output_file_path)
