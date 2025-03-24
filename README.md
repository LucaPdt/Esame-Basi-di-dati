# progetto basi di dati

studente: Luca Pedotti

## manuale utente

per il corretto funzionamento dell'applicazione si devono disporre dei seguenti software:

-   postgresSQL:

    il dbms utilizzato e sul quale verra' importato il dump della base di dati

    [download postgres](https://www.postgresql.org/download/)

-   PHP:

    linguaggio di scripting interpretato, utilizzato per coumincare con il database dall'applicazione web e per rendere quest'ultima dinamica

    si installa con XAMPP

-   XAMPP:

    programma utilizzato per avere un application server in locale su cui utilizzare l'applicazione web

    non c'e' bisogno di installare PHP manualmente in quanto ci pensera' l'installer di XAMPP

    [download xampp](https://www.apachefriends.org/it/index.html)

    una volta installato, inserire i file sorgente dell'applicazione web nella cartella `htdocs`, o la cartella alternativa scelta in fase di installazione

    dopodiche' bastera' avviare il server e digitare `localhost/index.php` nella barra di ricerca di un browser 

-   google chrome o un altro browser:

    server per poter visualizzare ed utilizzare l'applicazione web

    [download chrome](https://www.google.com/chrome/)

- come libreria per il front end dell'applicazione web ho utilizzato bootstrap

    [pagina di bootstrap](https://getbootstrap.com/)

</br>

## setup database e connessione web_app

per impostare il database si puo' utilizzare il file di dump fornito che comprende lo schema e qualche dato di prova

per importare il dump, creare prima un database:

- aprire un terminale e inserire il comando:

    ```
    > createdb nome_database
    ```

- dopodiche' per importare il dump bisogna eseguire questo comando:

    ```
    > psql -d nome_database -f dump_esame
    ```

    dove `dump_esame` e' il nome del file di dump fornito

</br>

### setup connessione

di default l'applicazione web e' impostata per connettersi al database tramite user postgres e password postgres, se si vuole modificare la stringa di connessione per rispecchiare le utente del sistema in uso modifica la stringa: `$stringa_connessione` a riga 5 del file `funzioni.php` impostando user e password desiderati

</br>

## manuale applicazione web

- ### pagina login (index.php):

    inserire il proprio username e password, a seconda del tipo utente associato all'username verra' caricata la pagina realtiva alla vostra utenza

    [docente](#docente)

    [studente](#studente)

    [segreteria](#segreteria)

    </br>

- ### segreteria

    la pagina di home mostra un messaggio di benvenuto con link di logout, cambio password e i dati relativi all'utente

    sotto di essi si trova una navbar, utile per muoversi tra le varie operazioni che un utente segreteria puo' effettuare interfacciandosi con la base di dati

    - `gestione utenti`:

        per inserire, rimuovere o aggiornare un profilo utente

        - inserimento:

            per prima cosa selezionare il tipo utente che si vuole inserire tramite l'apposito menu' a tendina

            a seconda del tipo utente scelto verra' mostrato il form con i campi relativi a quel tipo utente, premere invia per confermare

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
        
        - rimozione:

            per prima cosa selezionare il metodo di rimozione:

            - per username:

                inserire l'username dell'utente da rimuovere
            
            - per selezione:

                selezionare il tipo utente, e da qui scegliere tramite l'apposito link dalla tabella l'utente che si desidera rimuovere
            
            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
        
        - aggiornamento:

            selezione analoga alla rimozione, una volta selezionato l'utente comparira' il form di aggiornamento che contiene i vecchi dati preinseriti con la possibilita' di modificarli

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
    
    </br>

    - `gestione corsi di laurea`

        - inserimento:

            selezionare dal form, il docente responsabile e la tipologia del corso tramite l'apposito menu' a tendina

            inserire poi il nome del corso di laurea

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
        
        - aggiornamento:

            selezionare dalla lista tramite l'apposito link il corso di laurea che si vuole modificare

            verra' mostrato poi il form di aggiornamento precompilato con i vecchi dati relativi al corso con la possibilita' di modificarli

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
    
    </br>

    - `gestione insegnamenti`

        - inserisci insegnamento:

            selezionare dal form il corso di laurea nel quale si desidera inserire l'insegnamento e il docente responsabile tramite l'apposito menu' a tendina

            inserire poi gli altri dati a mano

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore

        - aggiorna insegnamento:

            selezionare il corso di laurea dell'insegnamento da modificare

            selezionare dalla lista tramite l'apposito link l'insegnamento che si desidera aggiornare

            comparira' poi il form di aggiornamento precompilato con i vecchi dati relativi all'insegnamento con la possibilita' di modificarli

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore

        - inserisci propedeuticita':

            selezionare il corso di laurea

            selezionare tramite gli appositi menu' a tendina il corso di laurea per il quale si vuole aggiungere una propedeuticita' e l'insegnamento propedeutico

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
        
        - rimuovi propedeuticita':

            selezionare il corso di laurea

            selezionare dalla lista tramite l'apposito link l'insegnamento che si vuole rimuovere

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore

    </br>

    - `carriere studenti`

        - carriera completa:

            seleziona dalla lista tramite l'apposito link lo studente per il quale si vuole vedere la carriera completa

        - carriera valida:

            seleziona dalla lista tramite l'apposito link lo studente per il quale si vuole vedere la carriera valida

</br>

- ### docente

    la pagina di home mostra un messaggio di benvenuto con link di logout, cambio password e i dati relativi all'utente

    sotto di essi si trova una navbar, utile per muoversi tra le varie operazioni che un utente docente puo' effettuare interfacciandosi con la base di dati

    - `gestione esami`

        - inserisci esame:

            mostra una tabella con gli insegnamenti di cui il docente e' responsabile

            seleziona tramite l'apposito link l'insegnamento per il quale si vuole aggiungere un esame

            inserisci la data

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore

        - rimuovi esame:

            mostra una tabella con gli esami definiti

            seleziona tramite l'apposito link l'esame da rimuovere

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
        
    - `esiti esami`

        pagina per inserire i voti degli esami

        seleziona dalla tabella tramite l'apposito link l'esame per il quale si vuole aggiungere un voto

        selezionare lo studente tramite il menu' a tendina che mostra solo gli studenti iscritti a quell'appello

        inserisci un voto da 0 a 30

        verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore

</br>

- ### docente

    la pagina di home mostra un messaggio di benvenuto con link di logout, cambio password e i dati relativi all'utente

    sotto di essi si trova una navbar, utile per muoversi tra le varie operazioni che uno studente puo' effettuare interfacciandosi con la base di dati

    - `carriere`

        - carriera completa:

            mostra la carriera completa dello studente

        - carriera valida:

            mostra la carriera valida dello studente

    - `esami`

        - iscrizione esame:

            selezionare tramite l'apposito link nella tabella l'esame a cui ci si vuole iscrivere

            verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore

        - controlla iscrizioni:

            mostra le iscrizioni effettuate per gli esami e ci da la possibilita' di rimuovere l'iscrizione tramite il relativo link

            in caso di rimozione verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore
        
    - `informazioni corsi`

        pagina che ci da' le informazioni sui corsi di laurea disponibili nell'ateneo

        seleziona tramite l'apposito link nella tabella il corso di laurea per il quale si vogliono vedere le informazioni

        compariranno poi le tabelle che mostrano gli insegnamenti e le propedeuticita' nel corso di laurea
    
    - `rinuncia agli studi`

        pagina che permette ad uno studente di rinunciare agli studi eliminando la sua utenza dal database ed inserendo i suoi dati studente e carriera nello storico

    - `laurea`

        pagina che permette ad uno studente che ha sostenuto con successo tutti gli esami di laurearsi

        la laurea comporta la rimozione dell'utenza dal database e lo spostamento delle sue informazioni nello storico

        verra' poi mostrato l'esito dell'operazione, se l'operazione fallisce verra' mostrato l'errore











