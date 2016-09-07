ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
}
set page_title "Quiz PF"
template::add_body_handler -event onLoad -script "acs_Focus('inizio', 'nome');"
ad_form -name inizio \
    -edit_buttons [list [list "Procedi" new]] \
    -has_edit 1 \
    -form {
	utente_id:key
	{nome:text
	    {label "Nome"}
	}
	{cognome:text
	    {label "Cognome"}
	}
	{email:text
	    {label "Email"}
	}
	{societa:text,optional
	    {label "Societ&agrave;"}
	}
	{provincia:text,optional
	    {label "Provincia"}
	}
    } -new_data {
	set utente_id [db_string query "select coalesce(max(utente_id) +1) from itfaw_utenti"]
	if {$utente_id eq ""} {
	    set utente_id 1
	}
	db_dml query "INSERT INTO itfaw_utenti (utente_id, nome, cognome, societa, email, provincia) values (:utente_id, :nome, :cognome, :societa, :email, :provincia)"
    } -after_submit {
	ad_returnredirect [export_vars -base "categorie-list" {utente_id}]
	ad_script_abort
    }
