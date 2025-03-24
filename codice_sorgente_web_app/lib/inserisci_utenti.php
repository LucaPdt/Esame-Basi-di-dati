<?php 
  include_once ('funzioni.php'); 
  session_start();
?>

<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>piattaforma universitaria inserimento utenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" ></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.min.js" integrity="sha384-Atwg2Pkwv9vp0ygtn1JAojH0nYbwNJLPhwyoVbhoPwBhjQPR5VtM2+xf0Uwh9KtT" crossorigin="anonymous"></script>

</head>
    <body>
        <?php
        ini_set("display_errors", "0");
        ini_set("error_reporting", "0");
        // se non vi e' una sessione valida aperta (presumibilmente in seguito ad un logout)
        // torno alla pagina di login
        if(!isset($_SESSION['user']) || $_SESSION['tipo_utente'] <> 'segreteria'){
            session_unset();
            $utente = null;
            header("Location:../index.php");
        }
        ?>
        
        <?php
        include_once('navbar_seg.php');
        ?>

        <div class="container pt-1 pb-3 mt-5 border">
          <h3 class="text-center">Servizio inserimento utenti</h3>
              </br>
              <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="GET">
                <div class="mb-3">
                    <label for="tipo_utente" class="form-label">Seleziona tipo utente</label>
                    <select class="form-select" id="tipo_utente" name="tipo_utente">
                        <option value="docente">Docente</option>
                        <option value="studente">Studente</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Seleziona</button>
              </form>
          <?php
          
          if(isset($_GET['tipo_utente']) && $_GET['tipo_utente'] == 'studente'){
            
            $_SESSION['usertype_insert'] = 'studente';
            $corsi_di_laurea = preleva_corsi();
            ?>
            <h3 class="text-center">Form inserimento studenti</h3>

            <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
                <div class="mb-3 pt-3">
                    <label for="cdl" class="form-label">Seleziona corso di laurea</label>
                    <select class="form-select" id="cdl" name="cdl">
                      <?php foreach ($corsi_di_laurea as $cdl) { ?>
                        <option value="<?php echo $cdl['id'];?>"> <?php echo $cdl['nome'] . ' (' . $cdl['tipologia'] . ')'; ?> </option>
                      <?php } ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password">
                </div>
                <div class="mb-3">
                    <label for="nome" class="form-label">Nome</label>
                    <input type="text" class="form-control" id="nome" name="nome">
                </div>
                <div class="mb-3">
                    <label for="cognome" class="form-label">cognome</label>
                    <input type="text" class="form-control" id="cognome" name="cognome">
                </div>
                <div class="mb-3">
                    <label for="e-mail" class="form-label">e-mail</label>
                    <input type="text" class="form-control" id="e-mail" name="e-mail">
                </div>
                <button type="submit" class="btn btn-primary">Invia</button>
                    
              </form>
            <?php } ?>
          
          <?php

          if(isset($_GET['tipo_utente']) && $_GET['tipo_utente'] == 'docente'){
            $_SESSION['usertype_insert'] = 'docente';

            ?>
            <h3 class="text-center">Form inserimento docenti</h3>

            <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
                <div class="mb-3 pt-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password">
                </div>
                <div class="mb-3">
                    <label for="nome" class="form-label">Nome</label>
                    <input type="text" class="form-control" id="nome" name="nome">
                </div>
                <div class="mb-3">
                    <label for="cognome" class="form-label">cognome</label>
                    <input type="text" class="form-control" id="cognome" name="cognome">
                </div>
                <div class="mb-3">
                    <label for="e-mail" class="form-label">e-mail</label>
                    <input type="text" class="form-control" id="e-mail" name="e-mail">
                </div>
                <button type="submit" class="btn btn-primary">Invia</button>
                    
              </form>
        <?php } ?>
        </div>

        <?php
        if(isset($_POST) && isset($_POST['username']) && isset($_POST['password']) && isset($_POST['nome']) && isset($_POST['cognome']) && isset($_POST['e-mail'])){
          
          // inserisco utente e relativamente studente o docente tramite una transazione, in modo che se una delle due operazioni fallisce eseguo un rollback
          if($_SESSION['usertype_insert'] == 'docente'){
            // eseguo funzione inserimento docente
            $esito = inserisci_docente($_POST['username'], $_POST['password'], 'docente', $_POST['nome'], $_POST['cognome'], $_POST['e-mail']);
          
          } else {
            // eseguo funzione inserimento studente
            $esito = inserisci_studente($_POST['username'], $_POST['password'], 'studente', $_POST['cdl'],  $_POST['nome'], $_POST['cognome'], $_POST['e-mail']);
          
          }
          
          switch($esito){

            case null:?>
              <div class="d-flex align-items-center justify-content-center" style="height: 150px;">
                <div class="p-3 mb-3 text-bg-danger rounded-1">errore nell'inserimento</div>
              </div>
              <?php break;
            
            case "successo": ?>
              <div class="d-flex align-items-center justify-content-center" style="height: 150px;">
                <div class="p-3 mb-3 text-bg-success rounded-1">inserimento riuscito</div>
              </div>
              <?php break;

            default: ?>
              <div class="d-flex align-items-center justify-content-center" style="height: 150px;">
                <div class="p-3 mb-3 text-bg-danger rounded-1"><?php echo($esito); ?></div>
              </div>
              <?php break;
            
          }


          unset($_SESSION['usertype_insert']);
        
        }
          ?>
    </body>
</html>


