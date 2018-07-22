#########Exercicio 1 e 2 

#Obtem caminho do diretorio de dados
fonte = "C:\\Users\\Carlos\\Downloads\\Perf_SpkUSL1jp1"

#Inicializa var dados
dados = NULL

#Inicializa dados_grupo
dados_grupo = NULL

#Obtem lista de diretorios
dirs = list.dirs(fonte, full.names = FALSE)

#Para cada diretorio, obtem seus arquivos, os processa, e inclui o grupo (nome dir)
for (i in 1:length(dirs)) {
  grupo = dirs[i]
  
  #Se vier como vazio, pula pro proximo
  if (grupo == "")
    next
  
  caminho_dir = paste(fonte, .Platform$file.sep, grupo, .Platform$file.sep, sep = "")
  
  lof = list.files(path = caminho_dir)
  
  dados_grupo = NULL
  
  tam_arq = length(lof)

  for (contador in 1:tam_arq) {
    nome_arq = lof[contador]
    
    #Concatena caminho e nome de arquivo
    caminho_arq = paste(caminho_dir, nome_arq, sep = "")

    #Le arquivo
    dados_arquivo = read.table(file = caminho_arq, sep = "\t", skip = 1, header = TRUE)
    
    #Funcao split vai usar o padrao ".txt" para remover a ultima parte do nome do arquivo
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
#checa o tipo de "dados"
typeof(dados)

#transforma em um datframe
as.data.frame(dados)
head(dados)

#determina o nome das colunas novas
dados = setNames(dados, c("Stimuli", "Condition", "Score", "Initials", 
                          "Gender", "Age", "Lang", "L1-L2", "Group"))

head(dados)

#transformando "Score" em fator numérico
typeof(dados$Score)
as.numeric(dados$Score)

#obtendo informacoes sobre a coluna "stimuli"
head(dados$Stimuli)
typeof(dados$Stimuli)

#a funcao str_split_fixed abaixo retorna os caracteres separados em tabela.
#A funcao strsplit só retorna como linha de caracter 
#e precisamos de enxerga-las como colunas; ou seja, tem que voltar como factor.
#por isso usamos a biblioteca para usar a funcao str_split_fixed.
#o numero 9 aparece dentro da função para indicar a quantidade de colunas que vai ser retornado
#os colchetes depois da funcao indica as colunas que quero que a função me retorne. 
#preciso usar uma virgula antes e os dois-pontos indicam "ate"

library(stringr)

cols_stimuli = as.data.frame(str_split_fixed(dados$Stimuli, "_", 9)[,4:8])

#checa as colunas criadas
head(cols_stimuli)

#cola as novas colunas a "dados"
dados = cbind(dados, cols_stimuli)

#determina nomes para as colunas novas
dados = setNames(dados, c("Stimuli", "Condition", "Score", "Initials", "Gender", "Age", "Lang", "L1-L2", 
                          "Group", "Speaker", "Spk-lang", "Spk-Level", "Attitude", "Sentence"))

#checa dados com atualizacoes
summary(dados)

##corrigindo inconsistências ortográficas
#ajustando os níveis de sexo (Gender)
levels(dados$Gender)
levels(dados$Gender) = toupper(levels(dados$Gender))
levels(dados$Gender)
summary(dados)

#ajustando os níveis de lingua (Lang)
levels(dados$Lang)
levels(dados$Lang) = toupper(levels(dados$Lang))
levels(dados$Lang) = c("EN", "JP")
levels(dados$Lang)
summary(dados)

#transformando "age" em fator numérico
typeof(dados$Age)
dados$Age=as.numeric(dados$Age)

#checa dados com atualizacoes
summary(dados)
