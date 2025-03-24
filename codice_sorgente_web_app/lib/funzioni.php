<?php
  ini_set ("display_errors", "On");
  ini_set("error_reporting", E_ALL);
  $stringa_connessione = "host=localhost dbname=esame user=postgres password=postgres";

function login($user, $pswd) {
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="SELECT username, tipo_utente FROM utente WHERE username = $1 AND password = $2";
        $res = pg_query_params($conn, $query, array($user, md5($pswd)));

        $result = pg_fetch_assoc($res);

        pg_close($conn);

        if($result){
                return $result;
            }
    }
}

function preleva_dati_corso($id){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="SELECT responsabile, tipologia, nome from corso_di_laurea where id = $1";
        $res = pg_query_params($conn, $query, array($id));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function preleva_dati_insegnamento($codice, $cdl){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="SELECT * from insegnamento where codice_univoco = $1 AND corso_di_laurea = $2";
        $res = pg_query_params($conn, $query, array($codice, $cdl));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function preleva_insegnamenti($cdl){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="SELECT * FROM insegnamento WHERE corso_di_laurea = $1";
        $res = pg_query_params($conn, $query, array($cdl));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }
}

function preleva_propedeuticita($cdl){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="SELECT insegnamento, propedeutico_a FROM propedeuticita WHERE corso_di_laurea1 = $1";
        $res = pg_query_params($conn, $query, array($cdl));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }
}

function preleva_iscritti($codice, $cdl, $data){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="SELECT s.nome, s.cognome, s.matricola FROM studente s JOIN iscrizione_esami ie ON s.matricola = ie.studente WHERE ie.insegnamento = $1 AND ie.corso_di_laurea = $2 AND ie.data = $3";
        $res = pg_query_params($conn, $query, array($codice, $cdl, $data));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }
}

// prelevo i dati relativi all'utente
function preleva_dati_segreteria($user){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="SELECT id, nome, cognome from segreteria where Utente = $1";
        $res = pg_query_params($conn, $query, array($user));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function preleva_dati_utente($user){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT username, tipo_utente from utente WHERE username = $1";
        $res = pg_query_params($conn, $query, array($user));
        
        if($res){
            $result = pg_fetch_assoc($res);
        } else {
            $result = array();
        }
        pg_close($conn);
        return $result;
    }
}

function preleva_dati_studente($user){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT matricola, corso_di_laurea, nome, cognome, e_mail from studente where Utente = $1";
        $res = pg_query_params($conn, $query, array($user));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function controlla_studente($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT 1 from studente where matricola = $1";
        $res = pg_query_params($conn, $query, array($matricola));
        $result = pg_fetch_assoc($res);
        
        if($result){
            return "attivo";
        }

        $query="SELECT matricola from storico_studente where matricola = $1";
        $res = pg_query_params($conn, $query, array($matricola));
        $result = pg_fetch_assoc($res);
        
        if($result){
            return "rimosso";
        }
    }
}

function preleva_dati_studente_id($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT matricola, corso_di_laurea, nome, cognome, e_mail from studente where matricola = $1";
        $res = pg_query_params($conn, $query, array($matricola));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function preleva_dati_studente_id_storico($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT matricola, corso_di_laurea, nome, cognome, e_mail from storico_studente where matricola = $1";
        $res = pg_query_params($conn, $query, array($matricola));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function preleva_possibili_responsabili_insegnamento(){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT d.id, d.nome, d.cognome, COUNT(i.codice_univoco)
        FROM docente d
        LEFT JOIN insegnamento i ON d.id = i.responsabile
        GROUP BY d.id
        HAVING COUNT(i.codice_univoco) < 3 OR COUNT(i.codice_univoco) IS NULL";
        $res = pg_query_params($conn, $query, array());

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }
}

function preleva_possibili_responsabili(){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT id, nome, cognome FROM docente WHERE id NOT IN( SELECT d.id FROM docente d JOIN corso_di_laurea c on d.id = c.responsabile)";
        $res = pg_query_params($conn, $query, array());

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}

function inserisci_esame($data, $codice, $cdl){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    $query="INSERT INTO esame(data, insegnamento, corso_di_laurea) VALUES ($1, $2, $3)";
    $res = pg_query_params($conn, $query, array($data, $codice, $cdl));
    
    if(!$res){
        $msg = pg_last_error($conn);
        // $errore = substr($msg, 0, strpos($msg, 'CONTEXT'));
        pg_close($conn);
        return $msg;
    }

    pg_close($conn);
    return "successo";
}

function inserisci_propedeuticita($insegnamento, $propedeutico_a, $cdl){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){

        $query="INSERT INTO propedeuticita(corso_di_laurea1, insegnamento, corso_di_laurea2, propedeutico_a) VALUES ($1, $2, $3, $4)";
        $res = pg_query_params($conn, $query, array($cdl, $insegnamento, $cdl, $propedeutico_a));
        
        if(!$res){
            $msg = pg_last_error($conn);
            // $errore = substr($msg, 0, strpos($msg, 'CONTEXT'));
            pg_close($conn);
            return $msg;
        }

    pg_close($conn);
    return "successo";
    }
    
}

function inserisci_voto($codice, $cdl, $data, $studente, $voto){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    $query="INSERT INTO carriera(data, insegnamento, corso_di_laurea, studente, voto) VALUES ($1, $2, $3, $4, $5)";
    $res = pg_query_params($conn, $query, array($data, $codice, $cdl, $studente, $voto));
    
    if(!$res){
        $msg = pg_last_error($conn);
        // $errore = substr($msg, 0, strpos($msg, 'CONTEXT'));
        pg_close($conn);
        return $msg;
    }

    pg_close($conn);
    return "successo";
}

function preleva_iscrizioni($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT * from iscrizione_esami where studente = $1";
        $res = pg_query_params($conn, $query, array($matricola));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }
}

function preleva_propedeuticita_r($cdl){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT * from propedeuticita where corso_di_laurea1 = $1";
        $res = pg_query_params($conn, $query, array($cdl));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }
}

function preleva_nome_insegnamento($cdl, $codice){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
        $query="SELECT nome from insegnamento where corso_di_laurea = $1 and codice_univoco = $2";
        $res = pg_query_params($conn, $query, array($cdl, $codice));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
}

function preleva_nome_corso($id){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
        $query="SELECT nome from corso_di_laurea where id = $1";
        $res = pg_query_params($conn, $query, array($id));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
}

function preleva_insegnamenti_per_responsabile($id){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT * FROM insegnamento WHERE responsabile = $1";
        $res = pg_query_params($conn, $query, array($id));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}

function preleva_tutti_studenti(){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT matricola, nome, cognome, e_mail FROM studente UNION SELECT matricola, nome, cognome, e_mail FROM storico_studente ORDER BY matricola";
        $res = pg_query_params($conn, $query, array());

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}

function preleva_carriera_completa($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query=
            "SELECT c.insegnamento, c.corso_di_laurea, c.data, c.voto, c.esito
            FROM carriera c 
            WHERE c.studente = $1
            ORDER BY c.insegnamento, c.data";
        $res = pg_query_params($conn, $query, array($matricola));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }
}

function preleva_carriera_valida($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query=
            "SELECT c.insegnamento, c.corso_di_laurea, c.data, c.voto, c.esito
            FROM carriera_valida c 
            WHERE c.studente = $1";
        $res = pg_query_params($conn, $query, array($matricola));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}

function preleva_carriera_valida_studente_rimosso($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query=
            "SELECT c.insegnamento, c.corso_di_laurea, c.data, c.voto 
            FROM carriera_valida_studenti_rimossi c 
            WHERE c.studente = $1";
        $res = pg_query_params($conn, $query, array($matricola));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}

function preleva_carriera_completa_studente_rimosso($matricola){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query=
        "SELECT c.insegnamento, c.corso_di_laurea, c.data, c.voto, c.esito
        FROM storico_carriera c 
        WHERE c.studente = $1
        ORDER BY c.data";
        $res = pg_query_params($conn, $query, array($matricola));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}

function preleva_dati_docente($user){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT id, nome, cognome, e_mail from docente where Utente = $1";
        $res = pg_query_params($conn, $query, array($user));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function preleva_esami_cdl($cdl){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query=
        "SELECT * FROM esame WHERE corso_di_laurea = $1 ORDER BY insegnamento, data";
        $res = pg_query_params($conn, $query, array($cdl));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}


function preleva_esami($id){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query=
        "SELECT e.*, i.nome
        FROM esame e JOIN insegnamento i ON e.corso_di_laurea = i.corso_di_laurea AND e.insegnamento = i.codice_univoco JOIN docente d ON d.id = i.responsabile 
        WHERE i.responsabile = $1";
        $res = pg_query_params($conn, $query, array($id));

        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }

        pg_close($conn);
        return $result;
    }

}

function preleva_dati_docente_per_id($id){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT id, nome, cognome from docente where id = $1";
        $res = pg_query_params($conn, $query, array($id));

        // prelevo il risultato sotto forma di array
        $result = pg_fetch_assoc($res);
        
        pg_close($conn);
        
        if($result){
            return $result;
        }
    }
}

function preleva_corsi(){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT id, responsabile, nome, tipologia from corso_di_laurea ORDER BY nome";
        $res = pg_query_params($conn, $query, array());
        
        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }
        pg_close($conn);
        return $result;
    }
}

function preleva_studenti(){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT u.username, s.matricola, s.nome, s.cognome FROM utente u JOIN studente s ON u.username = s.utente ORDER BY s.matricola";
        $res = pg_query_params($conn, $query, array());
        
        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }
        pg_close($conn);
        return $result;
    }
}

function preleva_docenti(){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    if($conn){
        $query="SELECT u.username, d.id, d.nome, d.cognome FROM utente u JOIN docente d ON u.username = d.utente ORDER BY d.id";
        $res = pg_query_params($conn, $query, array());
        
        if($res){
            $result = pg_fetch_all($res);
        } else {
            $result = array();
        }
        pg_close($conn);
        return $result;
    }
}


function modifica_password($utente, $old_psw, $new_psw){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        
       
        // fai le varie query, allora qua ce molto importante capire come fetcahre gli errori per stampare in caso di errore il messaggio corretto\
        
        $query="SELECT password from utente where username = $1";
        $res = pg_query_params($conn, $query, array($utente));
        $result = pg_fetch_result($res, 0, 0);

        if($result <> $old_psw){
            pg_close($conn);
            // throw new Exception("la password vecchia non e' corretta");
            return false;
        
        } else {
            
            $query="UPDATE utente SET password = $1 WHERE username = $2";
            $res = pg_query_params($conn, $query, array($new_psw, $utente));
            if(pg_affected_rows($res) == 1){
                pg_close($conn);
                return 'success';
            } else {
                pg_last_error($conn);
                pg_close($conn);
                return 'insuccess';
            } 
        }
    }
}

function aggiorna_docente($userold, $usernew, $nome, $cognome, $e_mail){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        // Inizia la transazione
        pg_query($conn, "BEGIN");
        $query="UPDATE utente SET username = $1 WHERE username = $2";
        $res = pg_query_params($conn, $query, array($usernew, $userold));
        
        if(!$res){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }

        $query_docente="UPDATE docente SET nome = $2, cognome = $3, e_mail = $4 WHERE utente = $1";
        $res_docente = pg_query_params($conn, $query_docente, array($usernew, $nome, $cognome, $e_mail));

        if(!$res_docente){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }
        
        pg_query($conn, "COMMIT");
        pg_close($conn);
        return "successo";
    }
}

function aggiorna_studente($userold, $usernew, $cdl, $nome, $cognome, $e_mail){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        // Inizia la transazione
        pg_query($conn, "BEGIN");
        $query="UPDATE utente SET username = $1 WHERE username = $2";
        $res = pg_query_params($conn, $query, array($usernew, $userold));
        
        if(!$res){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }

        $query_studente="UPDATE studente SET corso_di_laurea = $5, nome = $2, cognome = $3, e_mail = $4 WHERE utente = $1";
        $res_studente = pg_query_params($conn, $query_studente, array($usernew, $nome, $cognome, $e_mail, $cdl));

        if(!$res_studente){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }
        
        pg_query($conn, "COMMIT");
        pg_close($conn);
        return "successo";
    }
}

function aggiorna_cdl($id, $responsabile, $tipologia, $nome){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="UPDATE corso_di_laurea SET responsabile = $2, tipologia = $3, nome = $4 WHERE id = $1";
        $res = pg_query_params($conn, $query, array($id, $responsabile, $tipologia, $nome));
        
        if(!$res){
            $msg = pg_last_error($conn);
            pg_close($conn);
            return $msg;
        }
        
        pg_close($conn);
        return "successo";
    }
}

function aggiorna_insegnamento($codice, $cdl, $responsabile, $nome, $descrizione, $anno){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);

    if($conn){
        $query="UPDATE insegnamento SET responsabile = $3, nome = $4, descrizione = $5, anno = $6 WHERE codice_univoco = $1 AND corso_di_laurea = $2";
        $res = pg_query_params($conn, $query, array($codice, $cdl, $responsabile, $nome, $descrizione, $anno));
        
        if(!$res){
            $msg = pg_last_error($conn);
            // $errore = substr($msg, 0, strpos($msg, 'CONTEXT'));
            pg_close($conn);
            return $msg;
        }

        pg_close($conn);
        return "successo";
    }
}

function rimuovi_utente($username){
    global $stringa_connessione;
    
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="DELETE FROM utente WHERE username = $1";
        $res = pg_query_params($conn, $query, array($username));
        
        if(!$res){
            $msg = pg_last_error($conn);
            pg_close($conn);
            return $msg;
        }

        if(pg_affected_rows($res) == 1){
            pg_close($conn);
            return "success";
        } else {
            pg_close($conn);
            return false;
        }
    }
}

function rimuovi_propedeuticita($insegnamento, $cdl, $propedeutico_a){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="DELETE FROM propedeuticita WHERE insegnamento = $1 AND corso_di_laurea1 = $2 AND propedeutico_a = $3";
        $res = pg_query_params($conn, $query, array($insegnamento, $cdl, $propedeutico_a));
        
        if(!$res){
            pg_close($conn);
            return false;
        }

        if(pg_affected_rows($res) == 1){
            pg_close($conn);
            return true;
        } else {
            pg_close($conn);
            return false;
        }
    }
}

function rimuovi_esame($codice, $cdl, $data){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="DELETE FROM esame WHERE insegnamento = $1 AND corso_di_laurea = $2 AND data = $3";
        $res = pg_query_params($conn, $query, array($codice, $cdl, $data));
        
        if(!$res){
            pg_close($conn);
            return false;
        }

        if(pg_affected_rows($res) == 1){
            pg_close($conn);
            return true;
        } else {
            pg_close($conn);
            return false;
        }
    }
}

function rimuovi_iscrizione($data, $studente){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="DELETE FROM iscrizione_esami WHERE data = $1 AND studente = $2";
        $res = pg_query_params($conn, $query, array($data, $studente));
        
        if(!$res){
            pg_close($conn);
            return false;
        }

        if(pg_affected_rows($res) == 1){
            pg_close($conn);
            return true;
        } else {
            pg_close($conn);
            return false;
        }
    }
}

function inserisci_docente($username, $password, $tipo_utente, $nome, $cognome, $email){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        // Inizia la transazione
        pg_query($conn, "BEGIN");
        
        // Esegui la prima query per inserire l'utente
        $query_utente = "INSERT INTO utente VALUES($1, $2, $3)";
        $res = pg_query_params($conn, $query_utente, array($username, $password, $tipo_utente));

        if(!$res){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }

        // Esegui la seconda query per inserire il docente
        $query_docente = "INSERT INTO docente(utente, nome, cognome, e_mail) VALUES($1, $2, $3, $4)";
        $res_docente = pg_query_params($conn, $query_docente, array($username, $nome, $cognome, $email));

        if(!$res_docente){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }

        pg_query($conn, "COMMIT");
        pg_close($conn);
        return "successo";
    }
}

function inserisci_cdl($responsabile,  $tipologia, $nome){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="INSERT INTO corso_di_laurea( responsabile, tipologia, nome) VALUES( $1, $2, $3);";
        $res = pg_query_params($conn, $query, array($responsabile, $tipologia, $nome));

        if(!$res){
            $msg = pg_last_error($conn);
            pg_close($conn);
            return $msg;
        }

        pg_close($conn);
        return "successo";
    }

}

function inserisci_insegnamento($cdl, $responsabile, $nome, $descrizione, $anno){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="INSERT INTO insegnamento(corso_di_laurea, responsabile, nome, descrizione, anno) VALUES( $1, $2, $3, $4, $5)";
        $res = pg_query_params($conn, $query, array($cdl, $responsabile, $nome, $descrizione, $anno));

        if(!$res){
            $msg = pg_last_error($conn);
            // $errore = substr($msg, 0, strpos($msg, 'CONTEXT'));
            pg_close($conn);
            return $msg;
        }

        pg_close($conn);
        return "successo";
    }

}

function inserisci_studente($username, $password, $tipo_utente, $cdl, $nome, $cognome, $email){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        // Inizia la transazione
        pg_query($conn, "BEGIN");
        
        // Esegui la prima query per inserire l'utente
        $query_utente = "INSERT INTO utente VALUES($1, $2, $3)";
        $res = pg_query_params($conn, $query_utente, array($username, $password, $tipo_utente));

        if(!$res){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }

        // Esegui la seconda query per inserire lo studente
        $query_studente = "INSERT INTO studente(corso_di_laurea, utente, nome, cognome, e_mail) VALUES($1, $2, $3, $4, $5)";
        $res_studente = pg_query_params($conn, $query_studente, array($cdl, $username, $nome, $cognome, $email));

        if(!$res_studente){
            $msg = pg_last_error($conn);
            pg_query($conn, "ROLLBACK");
            pg_close($conn);
            return $msg;
        }

        pg_query($conn, "COMMIT");
        pg_close($conn);
        return "successo";
    }
}

function iscrizione_esame($codice, $cdl, $matricola, $data){
    global $stringa_connessione;
    $conn = pg_connect($stringa_connessione);
    
    if($conn){
        $query="INSERT INTO iscrizione_esami(data, insegnamento, corso_di_laurea, studente) VALUES( $1, $2, $3, $4)";
        $res = pg_query_params($conn, $query, array($data, $codice, $cdl, $matricola));

        if(!$res){
            $msg = pg_last_error($conn);
            // $errore = substr($msg, 0, strpos($msg, 'CONTEXT'));
            pg_close($conn);
            return $msg;
        }

        pg_close($conn);
        return "successo";
    }

}