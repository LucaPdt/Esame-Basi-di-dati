# progetto basi di dati

studente: Luca Pedotti

matricola: 978659

<br>

# prove di funzionamento

## login

se nel form di autenticazione si inseriscono dei dati sbagliati o non presenti nel database comparira' un messaggio di errore:

<br>
<p align="center">
<img width="740px" src=immagini/1.png />
</p>
<br>


se i dati sono corretti verra' invece caricata la pagina relatia al tipo utente con i suoi dati

</br>

## segreteria

pagina segreteria con i dati relativi all'utente

<br>
<p align="center">
<img width="740px" src=immagini/2.png />
</p>
<br>

- ### inserisci utenti

    utilizziamo i seguenti dati per simulare un inserimento:

    <br>
    <p align="center">
    <img width="740px" src=immagini/3.png />
    </p>
    <br>

    siccome i dati sono validi l'inserimento va a buon fine:

    <br>
    <p align="center">
    <img width="740px" src=immagini/4.png />
    </p>
    <br>

    se proviamo a reinserire gli stessi dati pero' giustamente l'inserimento non avviene e avremo un errore:

    <br>
    <p align="center">
    <img width="740px" src=immagini/5.png />
    </p>
    <br>

    in questo caso il primo errore trovato che interrompe la transazione e' il vincolo di chiave su utente username.

    </br>

- ### rimozione utenti

    - rimozione per username:

        si inserisce l'username dell'utente che si vuole eliminare, in questo caso proviamo ad eliminare l'utente inserito precedentemente:

        <br>
        <p align="center">
        <img width="740px" src=immagini/6.png />
        </p>
        <br>

        <br>
        <p align="center">
        <img width="740px" src=immagini/7.png />
        </p>
        <br>

        se provo a reinserire lo stesso username ci accorgiamo che la rimozione e' avvenuta veramente in quanto questa volta fallira':

        <br>
        <p align="center">
        <img width="740px" src=immagini/8.png />
        </p>
        <br>

    - la rimozione per selezione ci permette di vedere la lista di docenti e studenti, utile nel caso non sapessimo l'username da dover rimuovere:

        <br>
        <p align="center">
        <img width="740px" src=immagini/9.png />
        </p>
        <br>

        proviamo a rimuovere `studente5` per verificare ed effettivamente ricaricando la lista non e' presente

        <br>
        <p align="center">
        <img width="740px" src=immagini/10.png />
        </p>
        <br>
    
    </br>

- ### aggiorna utenti

    come per la rimozione si puo' selezionare l'utente da aggiornare dalle liste studente e docente:

    <br>
    <p align="center">
    <img width="740px" src=immagini/11.png />
    </p>
    <br>

    premendo sul link aggiorna comparira' il form con i vecchi dati preinseriti, permettendoci di modificare quello che desideriamo:

    <br>
    <p align="center">
    <img width="740px" src=immagini/12.png />
    </p>
    <br>

    anche qui se l'aggiornamento fallisce avremo un messaggio di errore inerente all'errore: in questo caso povo ad inserire un username che e' in utilizzo da un altro studente:

    <br>
    <p align="center">
    <img width="740px" src=immagini/13.png />
    </p>
    <br>

    </br>

- ### inserisci corso di laurea

    nella pagina di inserimento avremo una lista dei responsabili che sono elegibili per il ruolo di responsabile, ovvero che non sono ancora responsabili di altri CDL

    <br>
    <p align="center">
    <img width="740px" src=immagini/14.png />
    </p>
    <br>

    proviamo ad inserire un nuovo corso di laurea per verificare che il responsabile non compaia piu' nella lista: scegliamo 'Simone Romano'

    <br>
    <p align="center">
    <img width="740px" src=immagini/15.png />
    </p>
    <br>

    </br>

    l'inserimento e' riuscito e simone romano non compare piu' nella lista:

    <br>
    <p align="center">
    <img width="740px" src=immagini/16.png />
    </p>
    <br>

    </br>

- ### aggiornamento corso di laurea

    funziona in modo analogo all'aggiornamento degli utenti:

    si scegli il CDL da aggiornare e il form viene precompilato con i vecchi dati

    </br>

- ### inserimento insegnamento

    analogo all'inserimento dei corsi di laurea con la differenza che qui i docenti possono essere responsabili di 3 insegnamenti (quindi la lista dei possibili responsabili e' diversa)

    utilizziamo questo form per testare un messagio errore diverso da quelli visti, proviamo a inserire un valore di `anno` non valido

    <br>
    <p align="center">
    <img width="740px" src=immagini/17.png />
    </p>
    <br>

    avremo infatti l'errore relativo al trigger che controlla l'anno

    <br>
    <p align="center">
    <img width="740px" src=immagini/18.png />
    </p>
    <br>

    </br>

- ### inserisci propedeuticita'

    proviamo ad inserire una propedeuticita' non valida: ovvero provare ad inserire un insegnamento propedeutico di un anno uguale o superiore

    <br>
    <p align="center">
    <img width="740px" src=immagini/19.png />
    </p>
    <br>

    <br>
    <p align="center">
    <img width="740px" src=immagini/20.png />
    </p>
    <br>

    invece un inserimento valido avra' buon fine, facciamo una prova inserendo programmazione java come propedeutico a basi di dati avanzate:

    <br>
    <p align="center">
    <img width="740px" src=immagini/21.png />
    </p>
    <br>

    <br>
    <p align="center">
    <img width="740px" src=immagini/22.png />
    </p>
    <br>

    </br>

- ### rimuovi propedeuticita

    proviamo a rimuovere la propedeuticita' inserita in precedenza:

    <br>
    <p align="center">
    <img width="740px" src=immagini/23.png />
    </p>
    <br>

    <br>
    <p align="center">
    <img width="740px" src=immagini/24.png />
    </p>
    <br>
    
    la propedeuticita' viene rimossa e tolta dalla lista

    </br>

- ### carriere studenti

    la segreteria puo' visualizzare le carriere complete e valida di tutti gli studenti normali o rimossi

    mostro il funzionamento dalla pagina dello studente, in questo modo posso prima mostrare l'inserimento dei voti e le iscrizioni agli esami

</br>

## docente

pagina docente con i dati relativi al docente:

<br>
<p align="center">
<img width="740px" src=immagini/25.png />
</p>
<br>
</br>

- ### inserisci esame:

    ogni docente avra' la lista degli insegnamenti di cui e' responsabile e potra inserire degli esami per essi:

    <br>
    <p align="center">
    <img width="740px" src=immagini/26.png />
    </p>
    <br>
    </br>

    proviamo ad inserire 2 esami per ogni insegnamento dal relativo form che compare:

    <br>
    <p align="center">
    <img width="740px" src=immagini/27.png />
    </p>
    <br>
    </br>

    se si seleziona una data antecedente a quella odierna o una data che coincide con l'esame di un insegnamento appartenente allo stesso corso di laurea comparira' un errore relativo e l'inserimento e' bloccato

    <br>
    <p align="center">
    <img width="740px" src=immagini/28.png />
    </p>
    <br>
    </br>

    </br>

- ### rimuovi esame

    ogni docente vede la lista degli esami che ha stabilito:

    <br>
    <p align="center">
    <img width="740px" src=immagini/29.png />
    </p>
    <br>
    </br>

    proviamo a rimuovere un appello per basi di dati avanzate:

    <br>
    <p align="center">
    <img width="740px" src=immagini/30.png />
    </p>
    <br>
    </br>

- ### esiti esami

    un docente puo' inserire gli esiti agli studenti che si sono iscritti ai suoi appelli d'esame

    <br>
    <p align="center">
    <img width="740px" src=immagini/39.png />
    </p>
    <br>
    </br>

    se il voto non e' valido compare un errore

    <br>
    <p align="center">
    <img width="740px" src=immagini/40.png />
    </p>
    <br>
    </br>


</br>

## studente

home con i dati realtivi allo studente

<br>
<p align="center">
<img width="740px" src=immagini/31.png />
</p>
<br>
</br>

</br>

- ### iscrizione esami

    uno studente puo' iscriversi agli esami definiti per il suo corso di laurea

    <br>
    <p align="center">
    <img width="740px" src=immagini/32.png />
    </p>
    <br>
    </br>

    uno studente non puo' iscriversi 2 volte allo stesso esame o ad un esame di cui non ha superato le propedeuticita':

    <br>
    <p align="center">
    <img width="740px" src=immagini/33.png />
    </p>
    <br>
    </br>

    dopo aver sostenuto gli esami degli insegnamenti propedeutici con successo lo studente puo' iscriversi agli esami relativi:

    <br>
    <p align="center">
    <img width="740px" src=immagini/41.png />
    </p>
    <br>
    </br>

    <br>
    <p align="center">
    <img width="740px" src=immagini/42.png />
    </p>
    <br>
    </br>

    </br>

- ### controlla iscrizioni

    uno studente puo' verificare le sue iscrizioni agli esami e rimuoverle:

    <br>
    <p align="center">
    <img width="740px" src=immagini/34.png />
    </p>
    <br>
    </br>

    </br>

- ### informazioni corsi

    uno studente puo' verificare le informazioni dei corsi di laurea, contenenti gli insegnamenti presenti e le propedeuticita'

    <br>
    <p align="center">
    <img width="740px" src=immagini/35.png />
    </p>
    <br>
    </br>

    <br>
    <p align="center">
    <img width="740px" src=immagini/36.png />
    </p>
    <br>
    </br>

    </br>

- ### rinuncia agli studi/laurea

    tramite la rinuncia agli studi lo studente viene rimosso e inserito nello storico, non potra quindi piu accedere al app web

    la laurea fa la stessa cosa ma necessita che lo studente abbia superato con successo tutti gli esami degli insegnamenti del suo corso di laurea

    <br>
    <p align="center">
    <img width="740px" src=immagini/37.png />
    </p>
    <br>
    </br>

    <br>
    <p align="center">
    <img width="740px" src=immagini/38.png />
    </p>
    <br>
    </br>

    in questo caso la laurea non e' valida

    </br>

- ### carriera completa

    comprende gli esiti di tutti gli esami svolti

    <br>
    <p align="center">
    <img width="740px" src=immagini/43.png />
    </p>
    <br>
    </br>

    </br>

- ### carriera valida

    comprende la carriera valida, ovvero solo il voto piu' recente per ogni insegnamento e solo i voti con esito promosso

    <br>
    <p align="center">
    <img width="740px" src=immagini/44.png />
    </p>
    <br>
    </br>

</br>


## funzionamento delle tabelle storico:

quando uno studente viene rimosso dalla tabella studente, le sue informazioni sono spostate in storico_studente e i dati della sua carriera in storico_carriera:

<br>
<p align="center">
<img width="740px" src=immagini/finito.png />
</p>
<br>
</br>
