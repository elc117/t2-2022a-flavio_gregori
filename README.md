# Trabalho 2 - Aplicação Web em Prolog
Flávio Borin Júnior e Gregori Dallanora Rubin
## 1 - Web Scraping
Para acessarmos informações de uma página na web, o Prolog disponibiliza bibliotecas que suportam requisições HTTP. Com a biblioteca "http_open" podemos acessar a árvore DOM de uma página, que contém os detalhes de como é toda a sua estrutura.
	
```
http_open(Link, Stream, []).
load_html_file(Stream, DOM). %DOM recebe a estrutura da página
close(Stream).
```

Feito isso, utilizamos a biblioteca [xpath](https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/sgml.html%27)) do prolog, que, como o nome sugere, nos da suporte à linguagem xpath. Isso nos permite varrer o conteúdo da página em busca de uma informação específica. 
	
```
xpath(DOM, Path, Out). %onde path é o caminho para buscar o elemento
```

A paǵina escolhida foi [Family tree of the Greek gods](https://en.wikipedia.org/wiki/Family_tree_of_the_Greek_gods) por ter uma estrutura relativamente simples de ser varrida.
	
Neste caso, buscamos pelo nome e pelo link da página na Wikipedia de cada deus grego presente na lista. Esta operação nos resulta uma lista de elementos estruturados da seguinte maneira:
	
```
god(Nome, Link).
``` 
	
Essas estruturas são declaradas como um objeto json pela biblioteca json_convert, o que nos permite traduzir toda a lista de elementos para o formato JSON.

```
%transforma um elementos do prolog (Dictionary) para JSON
prolog_to_json(D, JsonNames). 
```

A ideia é, então criar uma espécie de API que retorna, sempre que acessada, um arquivo JSON que contém uma lista de deuses gregos e seus respectivos links na Wikipedia.

## 2 - Chuck Norris API
Para os testes iniciais sobre o funcionamento das bibliotecas supracitadas, utilizamos uma [api](https://api.chucknorris.io/jokes/random?category=dev) que nos gera piadas do Chuck Norris. O resultado pode ser acessado no [github](https://github.com/Fleivio/ChuckNorrisProlog).
	
## Referências consultadas:

- [Swi-prolog HTTP support](https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/http.html%27))
- [Swi-prolog SGML/XML parser](https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/sgml.html%27))
- [Xpath cheatsheet](https://devhints.io/xpath)