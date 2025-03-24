CREATE DOMAIN tipologia_corso AS varchar(10)
    CHECK (VALUE IN( 'triennale', 'magistrale'));

CREATE DOMAIN usertype AS varchar(10)
    CHECK (VALUE IN( 'segreteria', 'docente', 'studente'));

CREATE TABLE utente(
    username varchar(20) PRIMARY KEY,
    password TEXT NOT NULL,
    tipo_utente usertype NOT NULL
);

CREATE TABLE segreteria(
    id SERIAL PRIMARY KEY,
    utente varchar(20) references utente(username) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL UNIQUE,
    nome varchar(20),
    cognome varchar(20)
);

CREATE TABLE docente(
    id serial PRIMARY KEY,
    utente varchar(20) references utente(username) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL UNIQUE,
    nome varchar(20),
    cognome varchar(20),
    e_mail varchar(30) UNIQUE
);

CREATE TABLE corso_di_laurea(
    id serial PRIMARY KEY,
    responsabile integer references docente(id) NOT NULL,
    tipologia tipologia_corso NOT NULL,
    nome varchar(30) NOT NULL,
    UNIQUE (tipologia, nome)
);

CREATE TABLE studente(
    matricola serial PRIMARY KEY,
    corso_di_laurea integer references corso_di_laurea(id) ON UPDATE CASCADE NOT NULL,
    utente varchar(20) references utente(username) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL UNIQUE,
    nome varchar(20),
    cognome varchar(20),
    e_mail varchar(30) UNIQUE
);

CREATE TABLE insegnamento(
    codice_univoco serial NOT NULL,
    corso_di_laurea integer NOT NULL,
    responsabile integer references docente(id) NOT NULL,
    nome varchar(40) NOT NULL,
    descrizione text,
    anno smallint CHECK (anno > 0 AND anno < 4) NOT NULL,
    PRIMARY KEY(codice_univoco, corso_di_laurea),
    UNIQUE (corso_di_laurea, nome),
    FOREIGN KEY (corso_di_laurea) REFERENCES corso_di_laurea(id)
);

CREATE TABLE esame(
    corso_di_laurea integer NOT NULL,
    insegnamento integer NOT NULL,
    data date NOT NULL,
    PRIMARY KEY( corso_di_laurea, insegnamento, data),
    UNIQUE(corso_di_laurea, data),
    FOREIGN KEY (corso_di_laurea, insegnamento) REFERENCES insegnamento(corso_di_laurea, codice_univoco)
);

CREATE TABLE iscrizione_esami(
    data date NOT NULL,
    insegnamento integer NOT NULL,
    corso_di_laurea integer NOT NULL,
    studente integer NOT NULL,
    PRIMARY KEY(data, insegnamento, corso_di_laurea, studente),
    FOREIGN KEY (data, insegnamento, corso_di_laurea) REFERENCES esame (data, insegnamento, corso_di_laurea) ON DELETE CASCADE,
    FOREIGN KEY (studente) REFERENCES studente(matricola) ON DELETE CASCADE
);

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

CREATE TABLE storico_studente(
    matricola integer PRIMARY KEY,
    corso_di_laurea integer references corso_di_laurea(id)ON UPDATE CASCADE  NOT NULL,
    nome varchar(20),
    cognome varchar(20),
    e_mail varchar(30) UNIQUE
);

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

CREATE TABLE propedeuticita(
    corso_di_laurea1 integer NOT NULL,
    insegnamento integer NOT NULL,
    corso_di_laurea2 integer CHECK(corso_di_laurea1 = corso_di_laurea2) NOT NULL,
    propedeutico_a integer CHECK (insegnamento <> propedeutico_a) NOT NULL,
    PRIMARY KEY(corso_di_laurea1, insegnamento, propedeutico_a),
    FOREIGN KEY(corso_di_laurea1, insegnamento) REFERENCES insegnamento(corso_di_laurea, codice_univoco),
    FOREIGN KEY(corso_di_laurea2, propedeutico_a) REFERENCES insegnamento(corso_di_laurea, codice_univoco)
);

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


-- trigger e funzione per lo storico_studente

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


-- trigger che inserisce nello storico carriera

CREATE OR REPLACE FUNCTION inserimento_storico_carriera()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO storico_carriera (data, insegnamento, corso_di_laurea, studente, voto, esito)
    VALUES (OLD.data, OLD.insegnamento, OLD.corso_di_laurea, OLD.studente, OLD.voto, OLD.esito);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER inserimento_storico_carriera_trigger
AFTER DELETE ON carriera
FOR EACH ROW
EXECUTE FUNCTION inserimento_storico_carriera();



-- trigger che controlla che la data dell'esame non coincida con il giorno di altri esami gia stabiliti con lo stesso corso di laurea
-- ATTENZIONE trigger inutile in quanto ho il vincolo di chiave tra DATA e CORSO_DI_LAUREA ma e utile per l'applicazione web
CREATE OR REPLACE FUNCTION verifica_data_esami_univoca()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM esame
        WHERE corso_di_laurea = NEW.corso_di_laurea
          AND data = NEW.data
    ) THEN
        RAISE NOTICE 'Non e'' possibile inserire un record con la stessa data e corso di laurea.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verifica_data_esami_univoca
BEFORE INSERT OR UPDATE ON esame
FOR EACH ROW
EXECUTE FUNCTION verifica_data_esami_univoca();


-- trigger che controlla l'inserimento su carriera e che cancella il record relativo da iscrizione_esami in caso di inserimento riuscito

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
        RAISE exception 'Nessuna iscrizione trovata per l''esame';
        -- return null; se utilizzo raise notice devo usare questo comando
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_iscrizione_trigger
BEFORE INSERT ON carriera
FOR EACH ROW
EXECUTE FUNCTION verifica_iscrizione_esami();


-- trigger che controlla che l'iscrizione ad un esame sia valida (l'esame appartiene al corso di studi dello studente
-- e lo studente deve avere superato con esito positivo gli esami propedeutici)

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

    -- conto il numero di esami propedeutici all'esame che ci si vuole iscrivere
    SELECT count(*) INTO numero_propedeuticita
    FROM propedeuticita
    WHERE propedeutico_a = NEW.insegnamento;

    -- conto il numero di esami promossi per lo studente che si vuole iscrivere tra quelli propedeutici all'esame a cui si vuole iscrivere
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

-- trigger che controlla che non si inserica un valore di matricola nella tabella studente gia' presente nella tabella storico_studente
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

-- trigger che controlla che la data di un esame sia maggiore di quella odierna


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


-- trigger che controlla che un docente non sia responsabile di piu' di 1 corso di laurea
-- DA CONTROLLARE
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



-- trigger che controlla che un docente non sia responsabile di piu' di 3 insegnamenti
CREATE OR REPLACE FUNCTION controllo_numero_responsabile_insegnamenti()
RETURNS TRIGGER AS $$
DECLARE
    total_insegnamenti integer;
BEGIN
    SELECT COUNT(*) INTO total_insegnamenti
    FROM insegnamento
    WHERE responsabile = NEW.responsabile;

    IF total_insegnamenti >= 3  AND NEW.responsabile <> OLD.responsabile THEN
        RAISE EXCEPTION 'Un docente non puo'' essere responsabile di piu'' di 3 insegnamenti.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_controllo_numero_responsabile_insegnamenti
BEFORE INSERT OR UPDATE ON insegnamento
FOR EACH ROW
EXECUTE FUNCTION controllo_numero_responsabile_insegnamenti();



-- trigger che controlla che l'attributo anno di insegnamento assuma i valori corretti, per il corso di laura realtivo
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



-- trigger che controlla la coerenza delle propedeuticita'
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





-- INSERT

-- TABELLA UTENTE
INSERT INTO utente VALUES('segreteria1', 'seg1', 'segreteria');
INSERT INTO utente VALUES('segreteria2', 'seg2', 'segreteria');
INSERT INTO utente VALUES('segreteria3', 'seg3', 'segreteria');
INSERT INTO utente VALUES('segreteria4', 'seg4', 'segreteria');
INSERT INTO utente VALUES('segreteria5', 'seg5', 'segreteria');
INSERT INTO utente VALUES('segreteria6', 'seg6', 'segreteria');
INSERT INTO utente VALUES('segreteria7', 'seg7', 'segreteria');
INSERT INTO utente VALUES('segreteria8', 'seg8', 'segreteria');
INSERT INTO utente VALUES('segreteria9', 'seg9', 'segreteria');
INSERT INTO utente VALUES('segreteria10', 'seg10', 'segreteria');
INSERT INTO utente VALUES('segreteria11', 'seg11', 'segreteria');
INSERT INTO utente VALUES('segreteria12', 'seg12', 'segreteria');
INSERT INTO utente VALUES('segreteria13', 'seg13', 'segreteria');

INSERT INTO utente VALUES('studente1', 'stud1', 'studente');
INSERT INTO utente VALUES('studente2', 'stud2', 'studente');
INSERT INTO utente VALUES('studente3', 'stud3', 'studente');
INSERT INTO utente VALUES('studente4', 'stud4', 'studente');
INSERT INTO utente VALUES('studente5', 'stud5', 'studente');
INSERT INTO utente VALUES('studente6', 'stud6', 'studente');
INSERT INTO utente VALUES('studente7', 'stud7', 'studente');
INSERT INTO utente VALUES('studente8', 'stud8', 'studente');
INSERT INTO utente VALUES('studente9', 'stud9', 'studente');
INSERT INTO utente VALUES('studente10', 'stud10', 'studente');
INSERT INTO utente VALUES('studente11', 'stud11', 'studente');
INSERT INTO utente VALUES('studente12', 'stud12', 'studente');
INSERT INTO utente VALUES('studente13', 'stud13', 'studente');
INSERT INTO utente VALUES('studente14', 'stud14', 'studente');
INSERT INTO utente VALUES('studente15', 'stud15', 'studente');
INSERT INTO utente VALUES('studente16', 'stud16', 'studente');
INSERT INTO utente VALUES('studente17', 'stud17', 'studente');
INSERT INTO utente VALUES('studente18', 'stud18', 'studente');
INSERT INTO utente VALUES('studente19', 'stud19', 'studente');
INSERT INTO utente VALUES('studente20', 'stud20', 'studente');
INSERT INTO utente VALUES('studente21', 'stud21', 'studente');
INSERT INTO utente VALUES('studente22', 'stud22', 'studente');
INSERT INTO utente VALUES('studente23', 'stud23', 'studente');
INSERT INTO utente VALUES('studente24', 'stud24', 'studente');
INSERT INTO utente VALUES('studente25', 'stud25', 'studente');
INSERT INTO utente VALUES('studente26', 'stud26', 'studente');
INSERT INTO utente VALUES('studente27', 'stud27', 'studente');
INSERT INTO utente VALUES('studente28', 'stud28', 'studente');
INSERT INTO utente VALUES('studente29', 'stud29', 'studente');
INSERT INTO utente VALUES('studente30', 'stud30', 'studente');
INSERT INTO utente VALUES('studente31', 'stud31', 'studente');
INSERT INTO utente VALUES('studente32', 'stud32', 'studente');
INSERT INTO utente VALUES('studente33', 'stud33', 'studente');
INSERT INTO utente VALUES('studente34', 'stud34', 'studente');
INSERT INTO utente VALUES('studente35', 'stud35', 'studente');
INSERT INTO utente VALUES('studente36', 'stud36', 'studente');
INSERT INTO utente VALUES('studente37', 'stud37', 'studente');
INSERT INTO utente VALUES('studente38', 'stud38', 'studente');
INSERT INTO utente VALUES('studente39', 'stud39', 'studente');
INSERT INTO utente VALUES('studente40', 'stud40', 'studente');
INSERT INTO utente VALUES('studente41', 'stud41', 'studente');
INSERT INTO utente VALUES('studente42', 'stud42', 'studente');
INSERT INTO utente VALUES('studente43', 'stud43', 'studente');
INSERT INTO utente VALUES('studente44', 'stud44', 'studente');
INSERT INTO utente VALUES('studente45', 'stud45', 'studente');
INSERT INTO utente VALUES('studente46', 'stud46', 'studente');
INSERT INTO utente VALUES('studente47', 'stud47', 'studente');
INSERT INTO utente VALUES('studente48', 'stud48', 'studente');
INSERT INTO utente VALUES('studente49', 'stud49', 'studente');
INSERT INTO utente VALUES('studente50', 'stud50', 'studente');

INSERT INTO utente VALUES('docente1', 'doc1', 'docente');
INSERT INTO utente VALUES('docente2', 'doc2', 'docente');
INSERT INTO utente VALUES('docente3', 'doc3', 'docente');
INSERT INTO utente VALUES('docente4', 'doc4', 'docente');
INSERT INTO utente VALUES('docente5', 'doc5', 'docente');
INSERT INTO utente VALUES('docente6', 'doc6', 'docente');
INSERT INTO utente VALUES('docente7', 'doc7', 'docente');
INSERT INTO utente VALUES('docente8', 'doc8', 'docente');
INSERT INTO utente VALUES('docente9', 'doc9', 'docente');
INSERT INTO utente VALUES('docente10', 'doc10', 'docente');
INSERT INTO utente VALUES('docente11', 'doc11', 'docente');
INSERT INTO utente VALUES('docente12', 'doc12', 'docente');
INSERT INTO utente VALUES('docente13', 'doc13', 'docente');
INSERT INTO utente VALUES('docente14', 'doc14', 'docente');
INSERT INTO utente VALUES('docente15', 'doc15', 'docente');
INSERT INTO utente VALUES('docente16', 'doc16', 'docente');
INSERT INTO utente VALUES('docente17', 'doc17', 'docente');
INSERT INTO utente VALUES('docente18', 'doc18', 'docente');
INSERT INTO utente VALUES('docente19', 'doc19', 'docente');
INSERT INTO utente VALUES('docente20', 'doc20', 'docente');


-- TABELLA SEGRETERIA
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria1', 'Luca', 'Rossi');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria2', 'Alessia', 'Bianchi');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria3', 'Marco', 'Ricci');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria4', 'Elena', 'Martini');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria5', 'Davide', 'Conti');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria6', 'Valentina', 'Ferrari');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria7', 'Federico', 'Rizzo');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria8', 'Chiara', 'Galli');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria9', 'Simone', 'Lombardi');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria10', 'Giulia', 'Costa');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria11', 'Lorenzo', 'Mancini');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria12', 'Martina', 'Romano');
INSERT INTO segreteria (utente, nome, cognome) VALUES ('segreteria13', 'Andrea', 'Marini');


-- TABELLA DOCENTE
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente1', 'Francesco', 'Bianchi', 'francesco.bianchi@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente2', 'Chiara', 'Rossi', 'chiara.rossi@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente3', 'Luca', 'Ferrari', 'luca.ferrari@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente4', 'Alessia', 'Ricci', 'alessia.ricci@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente5', 'Marco', 'Martini', 'marco.martini@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente6', 'Elena', 'Conti', 'elena.conti@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente7', 'Davide', 'Galli', 'davide.galli@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente8', 'Valentina', 'Lombardi', 'valentina.lombardi@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente9', 'Federico', 'Mancini', 'federico.mancini@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente10', 'Simone', 'Romano', 'simone.romano@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente11', 'Giulia', 'Marini', 'giulia.marini@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente12', 'Lorenzo', 'Rizzo', 'lorenzo.rizzo@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente13', 'Martina', 'Costa', 'martina.costa@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente14', 'Andrea', 'Galli', 'andrea.galli@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente15', 'Elisa', 'Bianchi', 'elisa.bianchi@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente16', 'Giovanni', 'Ricci', 'giovanni.ricci@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente17', 'Francesca', 'Ferrari', 'francesca.ferrari@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente18', 'Matteo', 'Martini', 'matteo.martini@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente19', 'Sara', 'Conti', 'sara.conti@example.com');
INSERT INTO docente (utente, nome, cognome, e_mail) VALUES ('docente20', 'Paolo', 'Galli', 'paolo.galli@example.com');


-- TABELLA CORSO_DI_LAUREA
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (1, 'triennale', 'Ingegneria meccanica');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (2, 'triennale', 'Informatica');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (3, 'magistrale', 'Informatica');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (4, 'triennale', 'Architettura');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (5, 'magistrale', 'Ingegneria Biomedica');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (6, 'triennale', 'Scienze politiche');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (7, 'magistrale', 'Ingeneria meccanica');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (8, 'triennale', 'Giurisprudenza');
INSERT INTO corso_di_laurea (responsabile, tipologia, nome) VALUES (9, 'magistrale', 'Psicologia clinica');


-- TABELLA STUDENTE
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente1', 'Lorenzo', 'Bianchi', 'lorenzo.bianchi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (2, 'studente2', 'Sofia', 'Rossi', 'sofia.rossi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (3, 'studente3', 'Matteo', 'Ferrari', 'matteo.ferrari@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (4, 'studente4', 'Alessia', 'Martini', 'alessia.martini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (5, 'studente5', 'Gabriele', 'Conti', 'gabriele.conti@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (6, 'studente6', 'Chiara', 'Galli', 'chiara.galli@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (7, 'studente7', 'Andrea', 'Rizzo', 'andrea.rizzo@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (8, 'studente8', 'Francesca', 'Lombardi', 'francesca.lombardi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (9, 'studente9', 'Luca', 'Mancini', 'luca.mancini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente10', 'Elena', 'Romano', 'elena.romano@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente11', 'Davide', 'Marini', 'davide.marini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente12', 'Alessandro', 'Russo', 'alessandro.russo@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (2, 'studente13', 'Martina', 'Galli', 'martina.galli@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (3, 'studente14', 'Davide', 'Ferrari', 'davide.ferrari@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (4, 'studente15', 'Valentina', 'Romano', 'valentina.romano@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (5, 'studente16', 'Federica', 'Marini', 'federica.marini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (6, 'studente17', 'Paolo', 'Rizzo', 'paolo.rizzo@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (7, 'studente18', 'Elisabetta', 'Costa', 'elisabetta.costa@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (8, 'studente19', 'Giacomo', 'Galli', 'giacomo.galli@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (9, 'studente20', 'Lorenzo', 'Ricci', 'lorenzo.ricci@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (2, 'studente21', 'Martina', 'Ricci', 'martina.ricci@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (3, 'studente22', 'Giovanni', 'Ferrari', 'giovanni.ferrari@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (4, 'studente23', 'Francesca', 'Bianchi', 'francesca.bianchi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (5, 'studente24', 'Matteo', 'Rossi', 'matteo.rossi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (6, 'studente25', 'Sara', 'Martini', 'sara.martini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (7, 'studente26', 'Lorenzo', 'Conti', 'lorenzo.conti@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (8, 'studente27', 'Elisa', 'Galli', 'elisa.galli@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (9, 'studente28', 'Marco', 'Rizzo', 'marco.rizzo@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente29', 'Alessio', 'Lombardi', 'alessio.lombardi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente30', 'Valentina', 'Mancini', 'valentina.mancini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (2, 'studente31', 'Ludovica', 'Romano', 'ludovica.romano@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (3, 'studente32', 'Daniele', 'Marini', 'daniele.marini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (4, 'studente33', 'Giulia', 'Ferrari', 'giulia.ferrari@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (5, 'studente34', 'Andrea', 'Bianchi', 'andrea.bianchi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (6, 'studente35', 'Elena', 'Rossi', 'elena.rossi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (7, 'studente36', 'Luca', 'Martini', 'luca.martini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (8, 'studente37', 'Chiara', 'Conti', 'chiara.conti@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (9, 'studente38', 'Davide', 'Galli', 'davide.galli@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente39', 'Valentina', 'Rizzo', 'valentina.rizzo@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente40', 'Federico', 'Lombardi', 'federico.lombardi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (2, 'studente41', 'Simona', 'Mancini', 'simona.mancini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (3, 'studente42', 'Giovanni', 'Romano', 'giovanni.romano@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (4, 'studente43', 'Francesca', 'Marini', 'francesca.marini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (5, 'studente44', 'Matteo', 'Ferrari', 'matteo.ferrari2@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (6, 'studente45', 'Sara', 'Bianchi', 'sara.bianchi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (7, 'studente46', 'Lorenzo', 'Rossi', 'lorenzo.rossi@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (8, 'studente47', 'Elisa', 'Martini', 'elisa.martini@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (9, 'studente48', 'Marco', 'Conti', 'marco.conti@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente49', 'Alessio', 'Galli', 'alessio.galli@example.com');
INSERT INTO studente (corso_di_laurea, utente, nome, cognome, e_mail) VALUES (1, 'studente50', 'Valentina', 'Rizzo', 'valentina.rizzo2@example.com');


-- TABELLA INSEGNAMENTO
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (1, 1, 'Meccanica delle Strutture', 'Studio delle strutture meccaniche', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (1, 2, 'Termodinamica Applicata', 'Studio delle leggi termodinamiche', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (1, 3, 'Progettazione di Macchine', 'Progettazione di sistemi meccanici', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (2, 4, 'Programmazione Java', 'Studio del linguaggio Java', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (2, 5, 'Algoritmi e Strutture Dati', 'Studio degli algoritmi e delle strutture dati', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (2, 6, 'Basi di Dati', 'Introduzione alle basi di dati', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (4, 7, 'Architettura del Rinascimento', 'Studio dell''architettura rinascimentale', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (4, 8, 'Progettazione degli Spazi Urbani', 'Pianificazione degli spazi urbani', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (4, 9, 'Restauro e Conservazione', 'Tecniche di restauro architettonico', 3);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (5, 10, 'Biomeccanica', 'Studio delle applicazioni biomeccaniche', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (5, 11, 'Strumentazione Biomedica', 'Studio degli strumenti biomedici', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (5, 12, 'Imaging Medico', 'Introduzione all''imaging medico', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (6, 13, 'Teoria Politica', 'Studio delle teorie politiche', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (6, 14, 'Sistemi Politici Comparati', 'Analisi dei sistemi politici internazionali', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (6, 15, 'Politiche Pubbliche', 'Analisi delle politiche pubbliche', 3);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (7, 16, 'Dinamica Strutturale', 'Studio della dinamica delle strutture', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (7, 17, 'Tecnologie Avanzate dei Materiali', 'Studio dei materiali avanzati', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (9, 18, 'Psicopatologia', 'Studio delle malattie mentali', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (9, 19, 'Psicoterapia', 'Studio delle tecniche psicoterapeutiche', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (9, 19, 'Psicoterapia Cognitivo-Comportamentale', 'Studio dell''approccio terapeutico cognitivo-comportamentale', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (9, 20, 'Psicodiagnostica', 'Studio delle metodologie diagnostiche in psicologia', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (3, 6, 'Intelligenza Artificiale', 'Studio dell''intelligenza artificiale', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (3, 5, 'Sistemi Distribuiti', 'Studio dei sistemi distribuiti', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (7, 17, 'Robotica Industriale', 'Studio della robotica industriale', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (7, 16, 'Simulazione e Modellistica', 'Studio della simulazione e modellistica', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (8, 14, 'Diritto Penale', 'Studio del diritto penale', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (8, 13, 'Diritto Civile', 'Studio del diritto civile', 1);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (2, 6, 'Basi di Dati Avanzate', 'Approfondimento sulle basi di dati', 3);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (2, 4, 'Sicurezza Informatica', 'Studio della sicurezza informatica', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (5, 12, 'Dispositivi Medici Avanzati', 'Studio dei dispositivi medici avanzati', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (2, 5, 'Reti di Calcolatori', 'Studio delle reti di calcolatori', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (6, 15, 'Economia Politica', 'Studio dell''economia politica', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (5, 11, 'Biologia Molecolare Applicata', 'Studio delle applicazioni della biologia molecolare', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (1, 1, 'Dinamica dei Fluidi', 'Studio dei fluidi in movimento', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (9, 20, 'Psicoterapia Psicoanalitica', 'Studio dell''approccio psicoanalitico alla psicoterapia', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (3, 3, 'Reti Neurali', 'Studio delle reti neurali artificiali', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (7, 16, 'Simulazione di Processi Industriali', 'Studio della simulazione di processi industriali', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (8, 14, 'Diritto del Lavoro', 'Studio del diritto del lavoro', 2);
INSERT INTO insegnamento (corso_di_laurea, responsabile, nome, descrizione, anno) VALUES (9, 18, 'Psicologia delle Relazioni', 'Studio delle dinamiche relazionali', 2);

-- PROPEDEUTICITA'
INSERT INTO propedeuticita VALUES(1, 1, 1, 3);
INSERT INTO propedeuticita VALUES(2, 6, 2, 28);
INSERT INTO propedeuticita VALUES(3, 22, 3, 36);
INSERT INTO propedeuticita VALUES(4, 7, 4, 9);
INSERT INTO propedeuticita VALUES(5, 11, 5, 30);
INSERT INTO propedeuticita VALUES(7, 24, 7, 25);
INSERT INTO propedeuticita VALUES(9, 18, 9, 21);
INSERT INTO propedeuticita VALUES(9, 18, 9, 20);
INSERT INTO propedeuticita VALUES(9, 19, 9, 35);