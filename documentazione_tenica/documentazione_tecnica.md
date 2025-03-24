# progetto basi di dati

studente: Luca Pedotti

matricola: 978659

<br>

# documentazione

## dizionario dei dati

`entita'`

| Entita' | Descrizione | Attributi | Identificatore |
|:-------:|:-----------:|:---------:|:--------------:|
|Studente| uno studente all'interno dell'universita'| matricola, nome, congome, e-mail | matrciola|
|Docente| un docente all'interno dell'universita'| id, nome, congome, e-mail | id|
|Corso di laurea| un corso di laurea all'interno dell'universita'| nome, tipologia| nome, tipologia|
|Insegnamento| un insegnamento emesso dall'universita' che fa riferimento ad uno specifico corso di laurea| codice univoco, nome, descrizione, anno| codice univoco, nome (corso di laurea), tipologia (corso di laurea)|
|Esame| un appello d'esame di uno specifico insegnamento | data | data, Insegnamento.codice_univoco, Corso_di_laurea.id |
|Storico_Studente| mantiene le informazioni di uno studente rimosso | matricola, nome , congome, e-mail | matricola |
| Segreteria | un segretario all'interno dell'universita' | id, nome , cognome | id|
|Utente | un utente dell'applicazione web che si interfaccia con la base di dati | tipo_utente, username, password | password |


<br>

`Associazioni`

| Associazione | Descrizione | Entita' coinvolte | Attributi|
|:---------:|:-----------:|:-----------------:|:-------:|
| iscrizione | associa uno studente al corso di laurea a cui e' iscritto, specificando l'anno di iscrizione | Corso di laurea (0,N), Studente(1,1) | anno |
| Composizione | associa un insegnamento al corso di laurea di cui fa parte | Corso di laurea (1,N), Insegnamento (1,1) | |
| Resonsabilita' Corso | associa un docente al corso di laurea di cui e' responsabile | Docente (0,1), Corso di laurea (1,1)| |
| responsabilita' insegnamento | associa un docente al/agli insegnamento/i di cui e' responsbile | Docente (0,3), Insegnamento (1,1) | |
| Propedeuticita'| associa un insegnamento agli insegnamenti di cui e' propedeutico | Insegnamento (0,N), Insegnamento (0,N) | |
| calendario | stabilisce il "calendario esami" associando ad ogni esame un insegnamento, ci da informazioni sulle date nelle quali gli studenti possono sostenere un esame per un dato insegnamento | Insegnamento (0,N), Esame (1,1)| |
| carriera | associa studenti ed esami, da' informazioni sul voto ottenuto dagli studenti che hanno sostenuto un determinato esame | Studente (0,N), Esame (0,N) | voto, esito|
| iscrizione_esami | associa studenti agli esami a cui sono iscritti | Studente (0,N), Esame (0,N) | |
| storico_carriera | associa studenti rimossi ad esami, da' informazioni sul voto ottenuto dagli studenti che hanno sostenuto un determinato esame | Storico_Studente (0,N), Esame (0,N) | Voto, esito|
| login_studente | associa un Utente (con tipo_utente = studente) ad uno Studente dandogli determinati permessi nell'applicazione web | Utente (1,1), Studente (1,1)| |
| login_docente | associa un Utente (con tipo_utene = docente) ad un Docente dandogli determinati permessi nell'applicazione web| Utente (1,1), Docente (1,1) | |
| login_segreteria | associa un Utente (con tipo_utente = segreteria) ad un occorrenza di Segreteria dandogli determinati permessi nell'applicazione web | Utente (1,1), Segreteria (1,1) | |
| iscrizione_passata| associa uno studente rimosso al corso di laurea a cui era iscritto | Corso di laurea (0,N), Storico_studente(1,1)| |


<br>

## vincoli sui dati

| Regole di vincolo |
|:-------------------:|
|(RV1) ogni docente e' responsabile di massimo 3 insegnamenti e al massimo di un corso di laurea|
|(RV2) l'attributo 'tipologia' puo' assumere solo valore "triennale" o "magistrale"|
|(RV3) l'attributo 'anno' di Insegnamento ha dominio [1,3]  se il corso di laurea a cui appartiene e' triennale mentre [1,2] se il corso di laurea e' magistrale|
|(RV4) l'attributo 'esito' di carriera deve avere valore sufficiente se voto e' >= 18, o valore insufficiente se voto < 18 |
|(RV5) uno studente puo' iscriversi ad un esame (in iscrizione_esami) relativo ad un determinato insegnamento, solo se ha gia' ottenuto in precedenza esito sufficiente per tutti gli esami relativi ad insegnamenti che sono propedeutici ad esso |
|(RV6) l'attributo 'voto' di carriera ha dominio [0,30]|
|(RV7) uno studente puo' sostenre un esame (in carriera) relativo ad un determinato insegnamento solo se questo e' previsto dal proprio corso di laurea |
|(RV8) esami relativi ad insegnamenti dello stesso corso di laurea non possono avere la stessa data |
|(RV9) l'attributo 'tipo_utente' di Utente puo' assumere solo valori (ha dominio): {"studente", "docente", "segreteria"}|
|(RV10) un Utente puo' partecipare all'associazione 'login_studente' solo se il suo 'tipo_utente' e' "studente"| 
|(RV11) un Utente puo' partecipare all'associazione 'login_docente' solo se il suo 'tipo_utente' e' "docente"|
|(RV12) un Utente puo' partecipare all'associazione 'login_segreteria' solo se il suo 'tipo_utente' e' "segreteria"|
|(RV13) le propedeuticita' possono essere definite solo tra insegnamenti dello stesso corso di laurea|
|(RV14) le propedeuticita' non possono creare cicli che renderebbe impossibile soddisfarle|
<br>

|Regole di derivazione|
|:-------------------:|
(RD1) l'attributo 'esito' di carriera e' derivato controllando il voto associato ad esso: sufficiente se voto >= 18, insufficiente se voto < 18|

<br>

<br>

# decisioni progettuali

## progettazione concettuale

### `Entita'`:

- Studente: 
    
    ho scelto di identificare l'entita' tramite l'attributo matricola, in quanto oltre ad essere richiesto dalle specifiche e' l'attributo che meglio identifica univocamente uno studente

    ho poi introdotto gli attributi: nome, cognome ed e-mail in quanto sono informazioni utili per rappresentare uno studente ed avere un modo per contattarlo

- Docente:

    ho scelto di identificare l'entita' tramite un attributo id, in quanto anche se e-mail e' univoco per natura utilizzarlo come identificatore risultava ambiguo, inoltre l'email potrebbe essere modificata in futuro comportando un cambiamento di molti record all'interno della base di dati

    ho introdotto gli attributi: nome, cognome ed e-mail in quanto sono informazioni utili per rappresentare un docente ed avere un modo per contattarlo

- Corso di laurea:

    inizialmente ho scelto di identificare l'entita' tramite 2 attributi: nome e tipologia in quanto potrebbero esserci 2 corsi di laurea con lo stesso nome ma tipologia diversa (es: informatica triennale, informatica magistrale), ma durante la ristrutturazione mi risultava molto comodo l'attributo ID per risparmiare spazio nelle relazioni che si identificano esternamente tramite questa entita' e per facilitare alcune operazioni.

- Insegnamento:

    ho scelto di identificare esternamente l'insegnamento tramite una associazione con Corso di laurea, in quanto oltre ad essere richiesto dalle specifiche, mi permette di distinguere molto facilmente insegnamenti con lo stesso nome ma con riferimento a corsi di laurea differenti

    gli altri attributi ci danno informazioni utili sull insegnamento in questione

- Esame:

    concetto che piu' mi ha fatto riflettere nello svolgimento del progetto: inizliamente ho pensato di crearla come entita' forte con attributi identificatori: "codice" e "data", in quanto non volevo identificare una entita' debole tramite un'altra entita' debole, ma mi sono poi reso conto che risultava molto comodo farlo per controllare diversi vincoli tra cui la data in esami dello stesso corso di laurea.

    tramite l'attributo 'data' identifico appelli diversi di uno stesso insegnamento

- Storico_studente: 

    entita' con gli stessi attributi di Studente in cui pero' sono contenuti i record degli studenti che sono stati rimossi da quest'ultima.

- Utente:

    contiene le informazioni relative agli utenti dell'applicazione web, ho scelto di identificare l'entita' con 'username' in quanto questo deve essere univoco per i fini dell'applicazione web

    ho introdotto gli attributi 'password' in quanto indispensabile per i fini dell'applicazione web e 'tipo_utente' per comodita' di gestione.

- Segreteria:

    ho scelto di inserire questa entita' in quanto mi sembrava utile avere informazioni sugli utenti segreteria che utilizzano l'applicazione web, identificata tramite 'id'

    ho inserito gli attributi 'nome' e 'cognome' per avere delle informazioni sullo stesso.

<br>

### `Associazioni`

- iscrizione:

    rappresenta a quale corso di laurea e' iscritto uno studente e quali studenti sono iscritti ad un corso di laurea

    le cardinalita:

    - Studente (1,1): in quanto uno studente e' per forza iscritto ad un corso di laurea e ad uno soltanto

    - Corso di laurea (0,N): 
        - minima 0: in quanto un corso di laurea puo non  avere studenti iscritti, per esempio durante la fase in cui viene definito
        - massima N: in quanto stiamo considerando corsi di laurea non a numero chiuso, quindi senza un limite di studenti che vi possono essere iscritti.

<br>

- responsabilita' corso:

    definisce il docente responsabile di un determinato corso di laurea

    le cardinalita':

    - Corso di laurea (1,1): un corso di laurea necessita di un responabile ma ne ha uno soltanto

    - Docente (0,1): un docente non per forza e' responsabile di un corso di laurea, ma e' al massimo responsabile di un solo corso di laurea.

- Responsabilita' insegnamento:

    definisce il docente responasbile di un insegnamento

    le cardinalita'

    - Docente (0,3): un docente puo' non essere responasbile di un insegnamento, ma e' al massimo responsabile di 3 insegnamenti

    - Insegnamento (1,1): un insegnamento deve avere e ha al massimo un responsabile.

- Propedeuticita':

    definisce gli insegnamenti propedeutici ad altri

    le cardinalita':

    - insegnamento (0,N) 
        
        - minima 0: un insegnamento puo' non essere propedeutico ad altri insegnamenti e puo' non avere propedeuticita'

        - massima N: un insengnamento puo' essere propedeutico a piu' insegnamenti e un insegnamento puo' avere piu' propedeuticita'.

<br>

- calendario:

    definisce il calendario degli esami per gli insegnamenti

    mette in relazione ogni esame all'insegnamento a cui si riferisce

    le cardinalita':

    - Insegnamento (0,N): un insegnamento puo' non avere acnora date per esami definite e puo' averne diverse

    - Esame (1,1): un esame puo' essere riferito ad un solo insegnamento e deve essere riferito ad un insegnamento.

- carriera:

    definisce le carrirere degli studenti per gli esami a cui hanno partecipato

    attributo Voto che ci dice il voto per un determinato studente su un determinato esame

    attributo esito che ci dice se il voto e' sufficiente o insuffuciente, e' un attributo derivabile ma ho preferito inserirlo per non doverlo rielaborare diverse volte, in quanto necessario per diverse operazioni

    le cardinalita':

    - Studente (0,N): uno studente puo' non aver svolto nessun esame e puo' averne svolti diversi

    - Esame (0,N): un esame puo' non essere svolto da alcun studente e puo' essere svolto da piu' studenti.

- Composizione:

    definisce gli insegnamenti all'interno dei corsi di laurea

    le cardinalita':

    - Corso di laurea (1,N): un corso di laurea non puo' non avere insegnamenti e puo' averne diversi

    - Insegnamento (1,1): e' entita' debole la cardinalita' e' (1,1) in quanto un insegnamento fa riferimento e appartiene ad un solo corso di laurea.

- iscrizione_esami:

    mostra a queli esami e' iscritto un determinato studente

    le cardinalita':

    - Studente (0,N): uno studente puo' non  essere iscritto ad alcun esame oppure puo' essere iscritto a diversi

    - Esame (0,N): un esame puo' non avere studenti iscritti oppure puo' averne diversi.

- storico_carriera:

    definisce le carrirere degli studenti rimossi per gli esami a cui hanno partecipato

    attributo Voto che ci dice il voto per un determinato studente su un determinato esame

    attributo esito che ci dice se il voto e' sufficiente o insuffuciente.

    le cardinalita':

    - Storico_studente (0,N): uno studente puo' non aver svolto nessun esame e puo' averne svolti diversi

    - Esame (0,N): un esame puo' non essere svolto da alcun studente e puo' essere svolto da piu' studenti.

- login_studente:

    associa un Utente ad uno studente

    le cardinalita':

    - Utente (1,1): ad un Utente e' associato un solo Studente

    - Studente (1,1): ad uno Studente e' associato un solo Utente.

- login_docente:

    associa un Utente ad un Docente

    le cardinalita':

    - Utente (1,1): ad un Utente e' associato un solo Docente

    - Docente (1,1): ad un Docente e' associato un solo Utente.

- login_segreteria:

    associa un Utente ad un occorrenza di Segreteria

    le cardinalita':

    - Utente (1,1): ad un Utente e' associato una sola Segreteria

    - Segreteria (1,1): una Segreteria e' associata ad un solo Utente.

- iscrizione_passata:

    rappresenta a quale corso di laurea era iscritto uno studente rimosso

    le cardinalita:

    - Storico_studente (1,1): in quanto uno studente e' per forza iscritto ad un corso di laurea e ad uno soltanto

    - Corso di laurea (0,N): 
        - minima 0: in quanto un corso di laurea puo' non avere studenti nello storico che lo frequentavano
        - massima N: in quanto stiamo considerando corsi di laurea non a numero chiuso, quindi senza un limite di studenti che vi possono essere iscritti.
<br>

## progettazione logica

### `schema logico:`

<br>

- ```SQL
    CREATE DOMAIN tipologia_corso AS varchar(10)
        CHECK (VALUE IN( 'triennale', 'magistrale'));
    ```
    creazione del dominio: `tipologia_corso`, per l'attributo di corso_di_laurea che deve assumere solo valori: triennale o magistrale.

    </br>

- ```SQL
    CREATE DOMAIN usertype AS varchar(10)
        CHECK (VALUE IN( 'segreteria', 'docente', 'studente'));
    ```
    creazione del dominio: `usertype`, per l'attributo di utente che puo' assumere solo valori: segreteria, docente o studente.
    
    </br>

- ```SQL
    CREATE TABLE utente(
        username varchar(20) PRIMARY KEY,
        password TEXT NOT NULL,
        tipo_utente usertype NOT NULL
    );
    ```
    tabella `utente`:
        
    - attributo username: 
    
        attributo in cui viene salvato il nome con il quale si effettuera' l'accesso alla applicazione web, 
    
        varchar(20) in quanto mi sembra una lunghezza ragionevole

    - attributo password: 
    
        tipo text (non varchar in quanto viene cifrato), 
        
        NOT NULL in quanto la password e' essenziale

    - attributo tipo_utente: 
    
        attributo che identifica di che tipo utente si tratta

        usertype: dominio definito in precedenza
    
    - chiave primaria: username in quanto basta a identificare in modo univoco

         
- ```SQL
    CREATE TABLE segreteria(
        id SERIAL PRIMARY KEY,
        utente varchar(20) references utente(username) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL UNIQUE,
        nome varchar(20),
        cognome varchar(20)
    );
    ```
    tabella `segreteria``:

    - id:

        tipo serial in modo che sia un intero sempre univoco, gestito dal programma

    - utente: 
        
        vincolo di integrita' referenziale con la tabella utente in quanto strettamente collegata ad esso

        cascade su delete e update, in quanto se viene rimosso l'utente a cui la tupla di segreteria faceva riferimento, questa non ha piu' motivo di esistere, siccome il suo unico scopo e' quello di gestire un utenza per l'applicazione web, e se viene aggiornata, il riferimento deve restare integro

        NOT NULL: come detto prima, se non fa riferimento ad un utente una tupla non ha senso di esistere

        UNIQUE: un utente puo' essere associato ad una sola tupla di segreteria, in quanto definisce le regole di login

    - nome e cognome: attributi che forniscono informazioni sull'utenza 

    - chiave primaria: id, 
        
        avrei potuto utilizzare utente, ma ho preferito inserire un attributo adatto in quanto utente poteva risultare ambiguo

    </br>

- ```SQL
    CREATE TABLE docente(
        id serial PRIMARY KEY,
        utente varchar(20) references utente(username) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL UNIQUE,
        nome varchar(20),
        cognome varchar(20),
        e_mail varchar(30) UNIQUE
    );
    ```
    tabella `docente`:

    - id:

        tipo serial in modo che sia un intero sempre univoco, gestito dal programma
    
    - utente: 
        
        vincolo di integrita' referenziale con la tabella utente in quanto strettamente collegata ad esso

        cascade update, in quanto se l'istanza di utente viene aggiornata il vincolo deve persistere.

        NOT NULL: un docente deve sempre essere associato ad una tupla di utente altrimenti non potrebbe accedere all'applicazione web

        UNIQUE: un utente puo' essere associato ad una sola tupla di docente, in quanto definisce le regole di login

    - nome, cognome:

        attributi che forniscono informazioni sull'utenza

        varchar della lunghezza che ritenevo opportuna

    - e_mail:

        unique per la natura degli indirizzi e-mail

        varchar della lunghezza che ritenevo opportuna
    
    - chiave primaria: id
        
        avrei potuto utilizzare utente, ma ho preferito inserire un attributo adatto in quanto utente poteva risultare ambiguo

    </br>

- ```SQL
    CREATE TABLE corso_di_laurea(
        id serial PRIMARY KEY,
        responsabile integer references docente(id) NOT NULL,
        tipologia tipologia_corso NOT NULL,
        nome varchar(30) NOT NULL,
        UNIQUE (tipologia, nome)
    );
    ```

    tabella `corso_di_laurea`:

    - id:

        tipo serial in modo che sia un intero sempre univoco, gestito dal programma
    
    - responsabile:

        vincolo di integrita referenziale con la tabella docente

        NOT NULL in quanto un corso di laurea deve sempre avere un responsabile

        se si vuole eliminare il docente dal database bisogna prima cambiare il responsabile del corso
    
    - tipologia:

        attributo che specifica se il corso e' triennale o magistrale

        dominio opportunamente creato per non avere valori incoerenti

    - nome:

        varchar della lunghezza che ritenevo opportuna

        NOT NULL: per non avere dati ambigui

    - chiave primaria: id

    - unique(tipologia, nome):

        in quanto ci puo' essere un solo corso di laurea della stessa tipologia con quel nome, ma ci possono essere corsi di laurea con lo stesso nome di diverse categorie
    
    </br>

- ```SQL
    CREATE TABLE studente(
        matricola serial PRIMARY KEY,
        corso_di_laurea integer references corso_di_laurea(id) ON UPDATE CASCADE NOT NULL,
        utente varchar(20) references utente(username) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL UNIQUE,
        nome varchar(20),
        cognome varchar(20),
        e_mail varchar(30) UNIQUE
    );
    ```
    tabella `studente`:

    - matricola:

        tipo serial in modo che sia un intero sempre univoco, gestito dal programma
    
    - corso di laurea:

        vincolo di integrita referenziale con corso di laurea

        ON UPDATE CASCADE: in quanto se viene modificato il vincolo deve persistere

        NOT NULL: uno studente deve per forza essere iscritto ad un corso di laurea
    
    - utente:

        vincolo di integrita referenziale con utente

        UNIQUE: in quanto contiene le informazioni di login

        ON UPDATE CASCADE: in quanto se viene modificato l'utente collegato il vincolo deve persistere

        ON DELETE CASCADE: se viene cancellato l'utente collegato deve venire rimosso lo studente dal database (viene inserito nella tabella storico)

        NOT NULL: uno studente deve sempre avere modo di accedere all'aplicazione web
    
    - nome, cognome:

        attributi che forniscono informazioni sull'utenza

        varchar della lunghezza che ritenevo opportuna
    
    - e_mail:

        unique per la natura degli indirizzi e-mail

        varchar della lunghezza che ritenevo opportuna
    
    - chiave primaria: matricola 
        
        identifica in modo univoco uno studente nel database, necessario per impostare vincoli di integrita referenziale con altre tabelle

        richiesto inoltre dalle specifiche

    </br>

- ```SQL
    CREATE TABLE insegnamento(
        codice_univoco serial NOT NULL,
        corso_di_laurea integer NOT NULL,
        responsabile integer references docente(id) NOT NULL,
        nome varchar(40) NOT NULL,
        descrizione text,
        anno smallint CHECK (anno > 0 AND anno < 4) NOT NULL,
        PRIMARY KEY(codice_univoco, corso_di_laurea),
        UNIQUE (corso_di_laurea, nome)
        FOREIGN KEY (corso_di_laurea) REFERENCES corso_di_laurea(id)
    );
    ```

    tabella insegnamento:

    - codice_univcoco:

        tipo serial in modo da facilitare gli inserimenti e la gestione nel database
    
        NOT NULL in quanto serve ad identificare
    
    - corso_di_laurea:

        vincolo di integrita referenziale con corso di laurea:

        ci dice a quale corso di laurea fa riferimento l'insegnamento
    
    - responsabile:

        vincolo di integrita referenziale con docente:

        NOT NULL: in quanto un insegnamento deve per forza avere un responsabile (se si vuole eliminare il docente dal database bisogna prima modificare il responsabile)
    
    - nome:

        varchar della lunghezza che ritenevo opportuna

        NOT NULL per non avere dati ambigui
    
    - anno:

        intero da 1 a 3, ci da' informazioni sull'anno in cui e' previsto l'insegnamento all'interno del corso di laurea

        (un opportuna trigger controlla che l'anno non sia superiore a 2 per insegnamenti di corsi magistrali)

    - chiave primaria: codice_univoco, corso_di_laurea

        richiesto dalle specifiche, in quanto un insegnamento e' identificato all'interno di un corso di laurea

    - UNIQUE (corso_di_laurea, nome):

        in quanto ci puo' essere un solo insegnamento con un determinato nome in un corso di laurea
    
    - chiave esterna: corso_di_laurea(id)

    </br>

- ```SQL
    CREATE TABLE esame(
        corso_di_laurea integer NOT NULL,
        insegnamento integer NOT NULL,
        data date NOT NULL,
        PRIMARY KEY( corso_di_laurea, insegnamento, data),
        UNIQUE(corso_di_laurea, data),
        FOREIGN KEY (corso_di_laurea, insegnamento) REFERENCES insegnamento(corso_di_laurea, codice_univoco)
    );
    ```
    tabella `esame`:

    - corso di laurea ed insegnamento:

        vincoli di integrita referenziale con le tabelle relative

    - data:

        NOT NULL in quanto un esame deve per forza avere una data
    
    - chiave primaria: corso di laurea, insegnamento, data:

        un esame fa riferimento ad un insegnamento, che a sua volta fa riferimento ad un corso di laurea

        esami diversi per lo stesso insegnamento sono identificati in modo univoco dalla data
    
    - unique (corso_di_laurea, data):

        non ci possono essere esami con la stessa data nello stesso corso di laurea
    
    - chiave esterna: insegnamento, corso di laurea

    </br>

- ```SQL
    CREATE TABLE iscrizione_esami(
        data date NOT NULL,
        insegnamento integer NOT NULL,
        corso_di_laurea integer NOT NULL,
        studente integer NOT NULL,
        PRIMARY KEY(data, insegnamento, corso_di_laurea, studente),
        FOREIGN KEY (data, insegnamento, corso_di_laurea) REFERENCES esame (data, insegnamento, corso_di_laurea) ON DELETE CASCADE,
        FOREIGN KEY (studente) REFERENCES studente(matricola) ON DELETE CASCADE
    );
    ```
    tabella `iscrizione_esami`
    
    - data, insegnamento, corso di laurea

        NOT NULL in quanto chiavi esterne che servono ad identificare l'esame a cui si riferisce l'iscrizione
    
    - studente

        NOT NULL in quanto chiave esterna che identifica lo studente che ha effettuato l'iscrizione
    
    - chiave primaria: data, corso di laurea, insegnamento, studente

        composta da molti attributi ma e' il minimo per poter identificare le tuple in modo univoco

    </br>

- ```SQL
    CREATE TABLE carriera(
        data date NOT NULL,
        insegnamento integer NOT NULL,
        corso_di_laurea integer NOT NULL,
        studente integer NOT NULL,
        voto smallint CHECK( voto >= 0 AND voto <=30) NOT NULL,
        esito VARCHAR(8) GENERATED ALWAYS AS (
            CASE
            WHEN voto >= 18 THEN 'promosso'
            ELSE 'bocciato'
            END
        ) STORED,
        PRIMARY KEY(data, insegnamento, corso_di_laurea, studente),
        FOREIGN KEY (data, insegnamento, corso_di_laurea) REFERENCES esame (data, insegnamento, corso_di_laurea),
        FOREIGN KEY (studente) REFERENCES studente(matricola) ON DELETE CASCADE
    );
    ```
    tabella `carriera`

    - data, insegnamento, corso di laurea

        NOT NULL in quanto chiavi esterne che servono ad identificare l'esame a cui si riferisce il voto
    
    - studente:

        NOT NULL in quanto chiave esterna che identifica a quale studente appartiene il voto
    
    - voto:

        smallint che va da 0 a 30

        NOT NULL in quanto non avrebbe senso avere un voto nullo

    - esito:

        dato derivato calcolato automaticamente

        ho deciso di inserirlo per facilitare la gestione di alcune operazioni

    - chiave primaria: data, insegnamento, corso_di_laurea, studente

         composta da molti attributi ma e' il minimo per poter identificare le tuple in modo univoco
    
    </br>

- ```SQL

    CREATE TABLE storico_studente(
        matricola integer PRIMARY KEY,
        corso_di_laurea integer references corso_di_laurea(id)ON UPDATE CASCADE  NOT NULL,
        nome varchar(20),
        cognome varchar(20),
        e_mail varchar(30) UNIQUE
    );
    ```
    tabella `storico studente`

    - tabella in cui vengono inserite le tuple rimosse da `studente`

        ha la stessa logica di studente ma non dispone dell'attributo utente in quanto una volta rimosso uno studente non puo' piu' accedere all'applicazione web
    
    </br>

- ```SQL
    CREATE TABLE storico_carriera(
        data date NOT NULL,
        insegnamento integer NOT NULL,
        corso_di_laurea integer NOT NULL,
        studente integer NOT NULL,
        voto smallint CHECK( voto >= 0 AND voto <=30) NOT NULL,
        esito VARCHAR(8),
        PRIMARY KEY(data, insegnamento, corso_di_laurea, studente),
        FOREIGN KEY (data, insegnamento, corso_di_laurea) REFERENCES esame (data, insegnamento, corso_di_laurea),
        FOREIGN KEY (studente) REFERENCES storico_studente(matricola)
    );
    ```
    tabella `storico carriera`

    - tabella con la stessa logica di carriera ma con vincolo di integrita su storico_studente anziche studente

        vengono inserite qui le tuple degli studenti rimossi ed inseriti nello storico
    
    </br>

- ```SQL
    CREATE TABLE propedeuticita(
        corso_di_laurea1 integer NOT NULL,
        insegnamento integer NOT NULL,
        corso_di_laurea2 integer CHECK(corso_di_laurea1 = corso_di_laurea2) NOT NULL,
        propedeutico_a integer CHECK (insegnamento <> propedeutico_a) NOT NULL,
        PRIMARY KEY(corso_di_laurea1, insegnamento, propedeutico_a),
        FOREIGN KEY(corso_di_laurea1, insegnamento) REFERENCES insegnamento(corso_di_laurea, codice_univoco),
        FOREIGN KEY(corso_di_laurea2, propedeutico_a) REFERENCES insegnamento(corso_di_laurea, codice_univoco)
    );
    ```
    tabella `propedeuticita`:

    - insegnamento, corso_di_laurea1:

        identifica l'insegnamento che e' propedeutico
    
    - propedeutico_a, corso_di_laurea2:

        identifica l'insegnamento sul quale e' definita la propedeuticita'
    
    - corso di laurea2 deve essere uguale a corso di laurea1 in quanto non ha senso definire propedeuticita' tra corsi di laurea differenti

    - propedeutico_a e insegnamento devno esere differenti altrimenti non avrebbero senso

    - chiave primaria composta da tutti gli attributi in quanto sono presenti chiavi esterne di 2 insegnamenti differenti

    </br>

- ```SQL
    -- vista che include tutte le carriere valide degli studenti attivi
    CREATE VIEW carriera_valida AS 
        SELECT c.studente, c.insegnamento, c.corso_di_laurea, c.data, c.voto, c.esito
        FROM carriera c 
        WHERE c.esito = 'promosso' AND c.data = (
            SELECT MAX(c1.data)
            FROM carriera c1
            WHERE c1.insegnamento = c.insegnamento
            AND c1.corso_di_laurea = c.corso_di_laurea
            AND c1.studente = c.studente
        );
    ```
    vista `carriera valida`:

    - seleziona solo i voti di carriera con esito promosso

    - se presenti piu' voti per lo stesso insegnamento seleziona solo il voto relativo all'esame piu' recente

    </br>

- ```SQL
    -- vista che include tutte le carriere valide degli studenti rimossi
    CREATE VIEW carriera_valida_studenti_rimossi AS 
        SELECT c.studente, c.insegnamento, c.corso_di_laurea, c.data, c.voto, c.esito
        FROM storico_carriera c 
        WHERE c.esito = 'promosso' AND c.data = (
            SELECT MAX(c1.data)
            FROM storico_carriera c1
            WHERE c1.insegnamento = c.insegnamento
            AND c1.corso_di_laurea = c.corso_di_laurea
            AND c1.studente = c.studente
        );
    ```
    vista: `carriera valida studenti rimossi`:

    - come la vista carriera valida ma relativa alla tabella storico_carriera

</br>

## funzioni e trigger



- `trigger e funzione per lo storico_studente`

    ```SQL
    CREATE OR REPLACE FUNCTION inserimento_storico_studente()
    RETURNS TRIGGER AS $$
    BEGIN
        -- Inserisci il nuovo record nella tabella storico
        INSERT INTO storico_studente (matricola, corso_di_laurea, nome, cognome, e_mail)
        VALUES (old.matricola, old.corso_di_laurea, old.nome, old.cognome, old.e_mail);
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_inserimento_storico_studente
    BEFORE DELETE ON studente
    FOR EACH ROW
    EXECUTE FUNCTION inserimento_storico_studente();
    ```

    trigger che prima di eliminare una riga dalla tabella studente, inserisce una copia nella tabella storico_studente

    </br>  


- `trigger e funzione storico carriera`

    ```SQL
    CREATE OR REPLACE FUNCTION inserimento_storico_carriera()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO storico_carriera (data, insegnamento, corso_di_laurea, studente, voto, esito)
        VALUES (OLD.data, OLD.insegnamento, OLD.corso_di_laurea, OLD.studente, OLD.voto, OLD.esito);
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER inserimento_storico_carriera_trigger
    BEFORE DELETE ON carriera
    FOR EACH ROW
    EXECUTE FUNCTION inserimento_storico_carriera();
    ```

    trigger che prima di eliminare una riga dalla tabella carriera, inserisce una copia nella tabella storico_carriera
    
    ho scelto di utilizzare un BEOFRE trigger anziche un AFTER in quanto mi sembrava piu' sicuro (col BEFORE se ci sono problemi con l'inserimento nello storico la riga non viene eliminata)

    </br>


-   ```SQL
    CREATE OR REPLACE FUNCTION verifica_iscrizione_esami()
    RETURNS TRIGGER AS $$
    BEGIN
        -- Controlla se esiste un record in iscrizione_esami corrispondente
        IF EXISTS (
            SELECT 1
            FROM iscrizione_esami
            WHERE data = NEW.data
                AND insegnamento = NEW.insegnamento
                AND corso_di_laurea = NEW.corso_di_laurea
                AND studente = NEW.studente
        ) THEN
        
            -- Elimina il record corrispondente da iscrizione_esami
            DELETE FROM iscrizione_esami
            WHERE data = NEW.data
                AND insegnamento = NEW.insegnamento
                AND corso_di_laurea = NEW.corso_di_laurea
                AND studente = NEW.studente;
        ELSE
            -- Se non c'è un record corrispondente in iscrizione_esami, lancia un'eccezione
            RAISE EXCEPTION 'Nessuna iscrizione trovata per l''esame';
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER verifica_iscrizione_trigger
    BEFORE INSERT ON carriera
    FOR EACH ROW
    EXECUTE FUNCTION verifica_iscrizione_esami();
    ```

    trigger che controlla l'inserimento su carriera e che cancella il record relativo da iscrizione_esami in caso di inserimento riuscito

    trigger che avviene prima dell'inseriemento su carriera:

    - controlla se lo studente al quale si vuole dare il voto e' effettivamente iscritto all'esame

    - cancella l'iscrizione da iscrizione_esami

    - return NEW per inserire il voto in carriera

    </br>


-   ```SQL
    CREATE OR REPLACE FUNCTION controlla_validita_iscrizione()
    RETURNS TRIGGER AS $$
    DECLARE
    cdl_studente INTEGER;
    numero_propedeuticita INTEGER;
    numero_esami_promossi INTEGER;
    BEGIN
        -- Ottieni il corso di laurea dello studente
        
        SELECT corso_di_laurea INTO cdl_studente
        FROM studente
        WHERE matricola = NEW.studente;
        
        -- controllo che lo studente sia iscritto al corso di laurea dell'esame a cui si vuole iscrivere
        IF cdl_studente <> NEW.corso_di_laurea THEN
            RAISE EXCEPTION 'Lo studente non appartiene allo stesso corso di laurea dell''esame.';
        END IF;

        -- conto il numero di esami propedeutici all'esame a cui ci si vuole iscrivere
        SELECT count(*) INTO numero_propedeuticita
        FROM propedeuticita
        WHERE propedeutico_a = NEW.insegnamento;

        -- conto il numero di esami promossi per lo studente che si vuole iscrivere tra quelli propedeutici all'esame in questione
        -- controllo questo tramite un join tra carriera_valida (per non avere voti duplicati) e propedeuticita'
        SELECT count(*) INTO numero_esami_promossi
        FROM propedeuticita p JOIN carriera_valida c ON p.corso_di_laurea1 = c.corso_di_laurea AND p.insegnamento = c.insegnamento
        WHERE c.studente = NEW.studente AND p.corso_di_laurea1 = NEW.corso_di_laurea AND p.propedeutico_a = NEW.insegnamento AND c.esito = 'promosso';
        
        -- se i 2 numeri non coincidono sollevo un eccezione
        IF numero_propedeuticita <> numero_esami_promossi THEN
            RAISE EXCEPTION 'Studente non idoneo a iscriversi, non ha superato tutti gli esami propedeutici.';
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER controlla_validita_iscrizione_trigger
    BEFORE INSERT ON iscrizione_esami
    FOR EACH ROW
    EXECUTE FUNCTION controlla_validita_iscrizione();
    ```

    trigger che controlla che l'iscrizione ad un esame sia valida (l'esame appartiene al corso di studi dello studente e lo studente deve avere superato con esito positivo tutti gli esami propedeutici)

    BEFORE trigger in se il controllo non e' soddisfatto vogliamo prevenirne l'inserimento

    

- ```SQL
    CREATE OR REPLACE FUNCTION controlla_duplicati_studente()
    RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS (
            SELECT 1 FROM storico_studente WHERE matricola = NEW.matricola
        ) THEN
            RAISE EXCEPTION 'Impossibile inserire: matricola gia'' presente in storico_studente.';
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER previeni_duplicati_studente
    BEFORE INSERT OR UPDATE ON studente
    FOR EACH ROW
    EXECUTE FUNCTION controlla_duplicati_studente();
    ```

    trigger che controlla che non si inserica un valore di matricola nella tabella studente gia' presente nella tabella storico_studente

    </br>
    
    
- ```SQL
    CREATE OR REPLACE FUNCTION controlla_data()
    RETURNS TRIGGER AS $$
    BEGIN
        IF new.data < current_date THEN
            RAISE EXCEPTION 'Impossibile inserire un esame con data precedente alla data odierna';
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER blocca_inserimento_data
    BEFORE INSERT OR UPDATE ON esame
    FOR EACH ROW
    EXECUTE FUNCTION controlla_data();
    ```

    trigger che controlla che la data di un esame sia maggiore di quella odierna

    </br>


-   ```SQL
    CREATE OR REPLACE FUNCTION controllo_responsabilita_corso_di_laurea()
    RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM corso_di_laurea
            WHERE responsabile = NEW.responsabile
            AND id <> NEW.id
        ) THEN
            RAISE EXCEPTION 'Un docente puo'' essere responsabile di al massimo un corso di laurea.';
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_controllo_responsabilita_corso_di_laurea
    BEFORE INSERT OR UPDATE ON corso_di_laurea
    FOR EACH ROW
    EXECUTE FUNCTION controllo_responsabilita_corso_di_laurea();
    ```

    trigger che controlla che un docente non sia responsabile di piu' di 1 corso di laurea

    </br>


-   ```SQL
    CREATE OR REPLACE FUNCTION controllo_numero_responsabile_insegnamenti()
    RETURNS TRIGGER AS $$
    DECLARE
        total_insegnamenti integer;
    BEGIN
        SELECT COUNT(*) INTO total_insegnamenti
        FROM insegnamento
        WHERE responsabile = NEW.responsabile;

        IF total_insegnamenti >= 3  AND NEW.responsabile <> OLD.responsabile 
        THEN RAISE EXCEPTION 'Un docente non puo'' essere responsabile di piu'' di 3 insegnamenti.';
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_controllo_numero_responsabile_insegnamenti
    BEFORE INSERT OR UPDATE ON insegnamento
    FOR EACH ROW
    EXECUTE FUNCTION controllo_numero_responsabile_insegnamenti();
    ```

    trigger che controlla che un docente non sia responsabile di piu' di 3 insegnamenti

    seleziono in total_insegnamenti il numero di insegnamenti di cui e' attualmente responsabile, il docente in NEW

    se total_insegnamenti e' maggiore o uguale a 3 e il docente nuovo non coincide con quello vecchio sollevo una eccezione bloccando l'inserimento

    </br>


- ```SQL
    CREATE OR REPLACE FUNCTION controlla_validita_anno()
    RETURNS TRIGGER AS $$
    DECLARE
        tipologia_corso tipologia_corso;
    BEGIN
        SELECT tipologia INTO tipologia_corso
        FROM corso_di_laurea
        WHERE id = NEW.corso_di_laurea;
        
        IF tipologia_corso = 'triennale' AND (NEW.anno < 1 OR NEW.anno > 3) THEN
            RAISE EXCEPTION 'L''attributo anno deve essere compreso tra 1 e 3 per i corsi triennali';
        END IF;
        
        IF tipologia_corso = 'magistrale' AND (NEW.anno < 1 OR NEW.anno > 2) THEN
            RAISE EXCEPTION 'L''attributo anno deve essere compreso tra 1 e 2 per i corsi magistrali';
        END IF;
        
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_controlla_validita_anno
    BEFORE INSERT OR UPDATE ON insegnamento
    FOR EACH ROW
    EXECUTE FUNCTION controlla_validita_anno();
    ```

    trigger che controlla che l'attributo anno di insegnamento assuma i valori corretti, per il corso di laura realtivo

    </br>


- ```SQL
    CREATE OR REPLACE FUNCTION controllo_coerenza_propedeuticita()
    RETURNS TRIGGER AS $$
    BEGIN
        IF (SELECT anno FROM insegnamento WHERE codice_univoco = NEW.insegnamento) >= (SELECT anno FROM insegnamento WHERE codice_univoco = NEW.propedeutico_a) THEN
            RAISE EXCEPTION 'l''insegnamento propedeutico non puo'' essere di un anno maggiore';
        END IF;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_controllo_coerenza_propedeuticita
    BEFORE INSERT OR UPDATE ON propedeuticita
    FOR EACH ROW
    EXECUTE FUNCTION controllo_coerenza_propedeuticita();
    ```

    trigger che controlla la coerenza delle propedeuticita'

    </br>


-   ```SQL
    CREATE OR REPLACE FUNCTION cripta_password()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.password := MD5(NEW.password);
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER cripta_password_trigger
    BEFORE INSERT OR UPDATE ON utente
    FOR EACH ROW
    EXECUTE FUNCTION cripta_password();
    ```

    trigger che cripta le password prima di inserirle nel database