<?php 
  ini_set ("display_errors", "On");
  ini_set("error_reporting", E_ALL);
  include_once ('funzioni.php'); 
  session_start();

  ?>
  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>piattaforma universitaria cambio password</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    </head>
      <body>
          
          <?php
          // se hai cliccato il pulsante di reset, reinizializza
            if (isset($_POST['reset'])) {
               unset($esito);
               unset($_POST['reset']);
            }
          ?>

          <?php
          // se non vi e' una sessione aperta (presumibilmente in seguito ad un logout)
          // torno alla pagina di login
          if(!isset($_SESSION['user'])){
              session_unset();
              $utente = null;
              header("Location:../index.php");
          } else {
              $utente = $_SESSION['user'];
          }
          
          if(isset($_POST) && isset($_POST['old-psw']) && isset($_POST['pswd'])){
              
            $esito = modifica_password($utente, md5($_POST['old-psw']), $_POST['pswd']);

            if(!$esito){
            ?>
              <div class="d-flex align-items-center justify-content-center" style="height: 150px;">
                <div class="p-3 mb-3 text-bg-danger rounded-1">la password vecchia non coincide</div>
              </div>
            <?php
            }
          }
          ?>
        <?php if(!isset($esito) || !$esito){ ?>
        <div class="container mt-5 border">
          <h3 class="text-center">Servizio cambio password</h3>
              </br>
              <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
                  
                  <div class="form-floating mb-3">
                      <input type="password" class="form-control" id="old-psw" placeholder="inserici la vecchia password" name="old-psw">
                      <label for="old-psw">Inserisci la vecchia password</label>
              
                  </div>
                  <div class="form-floating mb-3">
                      <input type="password" class="form-control" placeholder="inserisci la nuova password" id="new-psw" name="pswd">
                      <label for="new-psw">Inserisci la nuova password</label>
                  </div>

                  <div class="row mb-3">
                      <div class="col-sm-2">
                          <button type="submit" class="btn btn-primary" style="width: 150px" value="Verify" name="verify">conferma</button>
                      </div>
                  </div>
              </form>
        </div>
        
        <?php } if (isset($esito) && $esito == 'success'){?>
        <div class="container mt-5 border border-dark-subtle border-2 bg-success-subtle">
          <h2 class="text-center">operazione terminata con successo</h2>
              </br>
                  <div class="row mb-3 justify-content-center">
                      <div class="col-sm-2">
                        <?php
                          switch($_SESSION['tipo_utente']){
                            case 'segreteria':
                              ?><a href="../segreteria.php" class="btn btn-primary" style="width: 150px">continua</a><?php
                              break;

                            case 'docente':
                              ?><a href="../docente.php" class="btn btn-primary" style="width: 150px" >continua</a><?php
                              break;
                              
                            case 'studente':
                              ?><a href="../studente.php" class="btn btn-primary" style="width: 150px" >continua</a><?php
                              break;
                        }
                        ?>
                      </div>
                  </div>
        </div>

      <?php } else if ( isset($esito) && $esito == 'insuccess') {?>
        <div class="container mt-5 border border-dark-subtle border-2 bg-danger-subtle">
          <h2 class="text-center">l'operazione non ha avuto successo</h3>
              </br>
              <div class="row mb-3 justify-content-center">
                      <div class="col-sm-3 ">
                        <?php
                          switch($_SESSION['tipo_utente']){
                            
                            case 'segreteria':
                              ?><a href="../segreteria.php" class="btn btn-primary" style="width: 250px">Torna alla pagina utente</a><?php
                              break;

                            case 'docente':
                              ?><a href="../docente.php" class="btn btn-primary" style="width: 250px" >Torna alla pagina utente</a><?php
                              break;
                              
                            case 'studente':
                              ?><a href="../studente.php" class="btn btn-primary" style="width: 250px" >Torna alla pagina utente</a><?php
                              break;
                              
                        }
                        ?>
                      </div>
                      <div class="col-sm-2">
                        <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
                          <button type="submit" class="btn btn-primary" style="width: 250px" name="reset">riprova</button>
                        </form>
                      </div>
                </div>
        </div>
        <?php } ?>             
        
        <?php
        if(!isset($esito)){
          switch($_SESSION['tipo_utente']){
            
            case 'segreteria':
              ?>
              <div class="d-flex mt-3 align-items-center justify-content-center">
                <a href="../segreteria.php" class="btn btn-danger" style="width: 250px">Torna alla pagina utente</a>
              </div>
              <?php
              break;

            case 'docente':
              ?>
              <div class="d-flex mt-3 align-items-center justify-content-center">
                <a href="../docente.php" class="btn btn-danger" style="width: 250px" >Torna alla pagina utente</a>
              </div>
              <?php
              break;
              
            case 'studente':
              ?>
              <div class="d-flex mt-3 align-items-center justify-content-center">
                <a href="../studente.php" class="btn btn-danger" style="width: 250px" >Torna alla pagina utente</a>
              </div>
              <?php
              break;
              
          }
        } ?>
    </body>
</html>