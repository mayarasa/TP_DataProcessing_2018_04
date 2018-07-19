#1 Extraction of the data from a set of files

#Caminho relativo do diretório de dados
fonte = "Perf_SpkUSL1jp1"

#Inicializa var dados
dados = NULL

#Obtém lista de diretórios
dirs = list.dirs(fonte, full.names = FALSE)
dirs

#Para cada diretório, obtém seus arquivos, os processa, e inclui o grupo (nome dir)
for (i in 1:length(dirs)) {
  grupo = dirs[i]
  
  #Se vier como vazio, pula pro próximo
  if (grupo == "")
    next
  
  caminho_dir = paste(fonte, .Platform$file.sep, grupo, .Platform$file.sep, sep = "")
  
  #Lê lista de nomes de arquivos
  lof = list.files(path = caminho_dir)
  
  #Inicializa var dados_grupo
  dados_grupo = NULL
  
  #Obtém tamanho da lista de nomes de arquivos
  tam_arq = length(lof)
  
  #Para cada arquivo no diretório (grupo) processa os dados e nome do arquivo
  for (contador in 1:tam_arq) {
    nome_arq = lof[contador]
    
    #Concatena caminho e nome de arquivo
    caminho_arq = paste(caminho_dir, nome_arq, sep = "")
    print("Lendo arquivo:")
    print(caminho_arq)
    
    #Lê arquivo
    dados_arquivo = read.table(file = caminho_arq, sep = "\t", skip = 1, header = TRUE)
    
    #Função split vai usar o padrão ".txt" para remover a última 
    #parte do nome do arquivo
    nome_sem_txt = unlist(strsplit(nome_arq, ".txt", fixed = TRUE))
    
    #Separa valores do nome do arquivo
    cols_nome_arq = strsplit(nome_sem_txt, "_")
    
    #Adiciona nos dados do arquivo cada um dos valores do nome do arquivo
    dados_arquivo = cbind(dados_arquivo, unlist(cols_nome_arq)[2])
    dados_arquivo = cbind(dados_arquivo, unlist(cols_nome_arq)[3])
    dados_arquivo = cbind(dados_arquivo, unlist(cols_nome_arq)[4])
    dados_arquivo = cbind(dados_arquivo, unlist(cols_nome_arq)[5])
    dados_arquivo = cbind(dados_arquivo, unlist(cols_nome_arq)[6])
    
    #Concatena dados
    dados_grupo = rbind(dados_grupo, dados_arquivo)
  }
  
  #Cria coluna com nome do grupo
  dados_grupo = cbind(dados_grupo, grupo)
  
  #Cola dados do grupo no resultado
  dados = rbind(dados, dados_grupo)
}

dados = setNames(dados, c("Stimuli", "Condition", "Score", "Sujeito", 
                          "Sexo", "Idade", "Língua", "L1/L2", "Grupo"))

levels(dados$Sexo) = tolower(levels(dados$Sexo))

levels(dados$Língua) = c("eg", "eg", "jp", "jp")

names(dados)
names(dados)[4]


table(dados$Sexo)
table(dados$Sexo, dados$Grupo)
##para separar as informações nos nomes da coluna ''stimuli''
##uso as.character dentro de strsplit porque ele estava como um factor até 
##então e o stri.split é só para caracter, não factor
strsplit(as.character(dados$Stimuli), "_")
library(stringr)
##a função str_split_fixed abaixo retorna os caracteres separados em tabela. 
##A função strsplit só retorna como linha de caracter e 
##precisamos de enxergá-las como colunas; ou seja, tem que voltar como factor.
## o número 9 aparece dentro da função para indicar a quantidade de colunas 
##que vai ser retornado
## os colchetes depois da função indica as colunas que quero que a função me 
##retorne. preciso usar uma vírgula antes e os dois-pontos indicam "até"
cols_stimuli <- as.data.frame(str_split_fixed(dados$Stimuli, "_", 9)[,4:8])
dados <- cbind(dados, cols_stimuli)
#TODO: setname das novas colunas:  “Speaker”, “Spk_lang”, “Spk_Level”, “Attitude”, “Sentence”



summary(dados)

