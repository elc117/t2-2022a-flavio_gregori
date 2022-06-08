:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

:- http_handler(root(.), home, []).
:- http_handler(root(style),  style, []).
:- http_handler(css('style.css'), http_reply_file('style.css', []), []).

http:location(css, root(.), []).

% Responde à requisição à rota root com o json
% jsonSend(_Request) :-
%     genJson(JsonNames),
%     reply_json(JsonNames).


% Responde à requisição à rota root com o conteúdo da página
home(_Request) :-
    getHtmlItems(B),
    A = [header(class(header), h1(class(title), 'Greek Gods')), div(class(main),B)],
    C = [\style],
    append(A,C,D),

    reply_html_page(title('Greek Gods'), link([rel('stylesheet'), href('./style.css')]), D).

style -->
        html([ \html_requires(css('style.css'))]).

% A partir da entrada de um nome e um link, gera um elemento
% HTML com essas informações.
htmlGen(god(Name, Link), Elem) :-
    Elem = a(href(Link), Name).

% A partir do documento JSON, aplica a função htmlGen para todas as entradas.
getHtmlItems(B) :- 
    genJson(JsonNames),
    json_to_prolog(JsonNames, A),
    gods(C) = A, 
    maplist(htmlGen, C, B).

% inicia o servidor
server(Port) :-
    http_server(http_dispatch,[port(Port)]).

:- initialization(server(8000)).


:- use_module(library(http/http_open)).
:- use_module(library(xpath)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).

% objetos para a biblioteca do json usar
:- json_object
        god(name, link).
:- json_object
        gods(god).

% envia a requisição à pagina e busca os elementos descritos em path
sendScrap(Link, Path, Out) :-
    http_open(Link, Stream, []),
    load_html_file(Stream, DOM),
    close(Stream),
    xpath(DOM, Path, Out).

% contem os argumentos da requisição à wikipedia
% também coloca os nome e os links das paginas em um vetor de objetos
formatScraping(MO):-
    Link = 'https://en.wikipedia.org/wiki/Family_tree_of_the_Greek_gods',
    Path = //td(@colspan = '6'),

    sendScrap(Link, Path, Elements),
    
    xpath(Elements, /td/a(content), N),
    [Name | _] = N,

    xpath(Elements, /td/a(@href), H),
    atom_concat('https://en.wikipedia.org', H, Href),
    MO = god(Name, Href).

% gera o json contendo os deuses
genJson(JsonNames) :-
    findall(Gods, formatScraping(Gods), A),
    prolog_to_json(A, N),
    gods(N) = G,
    prolog_to_json(G, JsonNames).