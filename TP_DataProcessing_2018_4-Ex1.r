#Caminho relativo do diret�rio de dados
fonte = ".\\Perf_SpkUSL1jp1\\"

#Inicializa var dados
dados = NULL

#Obt�m lista de diret�rios
dirs = list.dirs(fonte, full.names = FALSE)

#Para cada diret�rio, obt�m seus arquivos, os processa, e inclui o grupo (nome dir)
for (i in 1:length(dirs)) {
  grupo = dirs[i]
  
  #Se vier como vazio, pula pro pr�ximo
  if (grupo == "")
    next
  
  caminho_dir = paste(fonte, grupo, "\\", sep = "")
  
  #L� lista de nomes de arquivos
  lof = list.files(path = caminho_dir)
  
  #Inicializa var dados_grupo
  dados_grupo = NULL
  
  #Obt�m tamanho da lista de nomes de arquivos
  tam_arq = length(lof)
  
  #Para cada arquivo no diret�rio (grupo) processa os dados e nome do arquivo
  for (contador in 1:tam_arq) {
    nome_arq = lof[contador]
    
    #Concatena caminho e nome de arquivo
    caminho_arq = paste(caminho_dir, nome_arq, sep = "")
    
    #L� arquivo
    dados_arquivo = read.table(file = caminho_arq, sep = "\t", skip = 1, header = TRUE)
    
    #Fun��o split vai usar o padr�o ".txt" para remover a �ltima 
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

summary(dados)

#Estudar:
#hist(as.numeric(dados[3]))
#mean(unlist(dados[3]))
#sd(unlist(dados[3]))
#boxplot(unlist(dados[3]), as.factor(unlist(dados[5])))