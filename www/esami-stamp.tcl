ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 25 November 2014
} {
    esame_id:integer
}
set html "<html><table border=\"0\" width=\"100%\">"
# Imposta titolo testata
set title "Esame #"
append title $esame_id
# Imposta categoria e nome utente
#set utente [db_string query "SELECT i.nome||' '||i.cognome FROM pf_iscritti i, pf_esami e WHERE e.iscritto_id = i.iscritto_id AND e.esame_id = :esame_id"]
set barcode [db_string query "select i.barcode, i.utente_id from itfaw_utenti i, itfaw_esami e where e.utente_id = i.utente_id and e.esame_id = :esame_id"]
set categoria [db_string query "SELECT c.descrizione FROM categoriaevento c, itfaw_esami e WHERE e.categoria_id = c.categoria_id AND e.esame_id = :esame_id"]
append html "<tr><td colspan=\"1\" width=\"80%\"><center><font size=\"4em\" face=\"Helvetica\"><img src=\"http://app.mattiarighetti.it/pfawards/images/logo_pfawards.png\" height=\"30px\"></img><br><br>$title</font><br><font size=\"3em\" face=\"Helvetica\">Utente:  utente $barcode</font><br><font size=\"3em\" face=\"Helvetica\">Categoria: <u>$categoria</u></font></td>"
#Controllo esame risposto
set query01 [db_0or1row query "SELECT rispusr_id FROM itfaw_rispusr WHERE esame_id = :esame_id ORDER BY rispusr_id LIMIT 1"]
if {$query01 == 0} {
    ad_returnredirect "../index"
    ad_script_abort
}
#Estrae punteggio totalizzato
set total_score [db_string query "SELECT SUM(r.punti) FROM itfaw_rispusr s, itfaw_risposte r WHERE r.risposta_id = s.risposta_id AND s.esame_id = :esame_id"]
append html "<td><center><font face=\"Helvetica\" size=\"0.5em\"><b>Punteggio totale:</b></font><br><font face=\"Courier New\" size=\"18px\">$total_score</font></center></td></tr><tr><td colspan=\"2\"><br>&nbsp;<br></td></tr>"
# Ciclo di estrazione domande e risposte
set counter 1
db_foreach query "SELECT rispusr_id FROM itfaw_rispusr WHERE esame_id = :esame_id ORDER BY rispusr_id" {
    # Estrae corpo della domanda
    set domanda_id [db_string query "SELECT domanda_id FROM itfaw_rispusr WHERE rispusr_id = :rispusr_id"]
    set domanda [db_string query "SELECT d.corpo FROM itfaw_domande d, itfaw_rispusr r WHERE d.domanda_id = r.domanda_id AND r.rispusr_id = :rispusr_id"]
    append html "<tr><td colspan=\"2\"><font color=\"#333333\" face=\"Helvetica\" size=\"3.5em\"><b>$counter.    $domanda</b></font></td></tr>"
    # Estrae risposta data se vi è
    set query01 [db_0or1row query "SELECT risposta_id FROM itfaw_rispusr WHERE rispusr_id = :rispusr_id AND risposta_id IS NOT NULL"]
    if {$query01 == 1} {
	set rispostadata_id [db_string query "SELECT risposta_id FROM itfaw_rispusr WHERE rispusr_id = :rispusr_id"]
	set risposta [db_string query "SELECT corpo FROM itfaw_risposte WHERE risposta_id = :rispostadata_id"]
	# Controlla se la risposta data è giusta 
	set punti [db_string query "SELECT punti FROM itfaw_risposte WHERE risposta_id = :rispostadata_id"]
	if {$punti == 3 || $punti == 4} {
	    append html "<tr><td><font color=\"#000000\" face=\"Helvetica\">&nbsp;<img src=\"http://app.mattiarighetti.it/pfawards/images/tic.png\" width=\"10px\"></img>&nbsp;$risposta</font></td><td><center>$punti</center></td></tr>"
	} else {
	    append html "<tr><td><font color=\"#000000\" face=\"Helvetica\">&nbsp;<img src=\"http://app.mattiarighetti.it/pfawards/images/delete.gif\" width=\"10px\"></img>&nbsp;$risposta</font></td><td><center>$punti</center></tr>"
	}
	# Estrae le altre risposte
	db_foreach query "SELECT risposta_id FROM itfaw_risposte WHERE domanda_id = :domanda_id AND risposta_id <> :rispostadata_id ORDER BY RANDOM()" {
	    set risposta [db_string query "SELECT corpo FROM itfaw_risposte WHERE risposta_id = :risposta_id"]
	    set punti [db_string query "SELECT punti FROM itfaw_risposte WHERE risposta_id = :risposta_id"]
	    if {$punti == 3 || $punti == 4} {
		append html "<tr><td><font color=\"#1e1e1e\" face=\"Helvetica\">&nbsp; - $risposta (Punti: $punti)</font></td></tr>"
	    } else {
		append html "<tr><td><font color=\"#999999\" face=\"Helvetica\">&nbsp; - $risposta</font></td></tr>"
	    }
	}
    } else {
	db_foreach query "SELECT risposta_id FROM itfaw_risposte WHERE domanda_id = :domanda_id ORDER BY RANDOM()" {
            set risposta [db_string query "SELECT corpo FROM itfaw_risposte WHERE risposta_id = :risposta_id"]
            set punti [db_string query "SELECT punti FROM itfaw_risposte WHERE risposta_id = :risposta_id"]
            if {$punti == 3 || $punti == 4} {
                append html "<tr><td><font color=\"#1e1e1e\" face=\"Helvetica\">&nbsp; - $risposta (Punti: $punti)</font></td></tr>"
            } else {
                append html "<tr><td><font color=\"#999999\" face=\"Helvetica\">&nbsp; - $risposta</font></td></tr>"
            }
        }
    }
    incr counter
}
append html "</table>"
append html "</html>"
set filenamehtml "/tmp/esami-stamp.html"
set filenamepdf  "/tmp/esami-stamp.pdf"
set file_html [open $filenamehtml w]
puts $file_html $html
close $file_html
with_catch error_msg {
    exec htmldoc --portrait --webpage --charset utf8 --header ... --footer ... --quiet --left 1cm --right 1cm --top 1cm --bottom 1cm --fontsize 12 -f $filenamepdf $filenamehtml
} {
    ns_log notice "errore htmldoc  <code>$error_msg </code>"
}
ns_returnfile 200 application/pdf $filenamepdf
ns_unlink $filenamepdf
ns_unlink $filenamehtml
ad_script_abort
