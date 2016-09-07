ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Tuesday 28 October, 2014
} {
    utente_id:integer
}
set page_title "Scegli la categoria - PF"
template::list::create \
    -name categorie \
    -multirow categorie \
    -key caegoria_id \
    -elements {
	descrizione {
	    label "Categoria"
	}
        esame {
	    link_url_col esame_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/play.png" width="20px" height="20px" border="0">}
	    link_html {title "Comincia l'esame" onClick "return(confirm('Quando sei pronto clicca su OK e comincerà il test.'));" width="20px"}
	    sub_class narrow
	}
    } 
db_multirow \
    -extend {
	esame_url
    } categorie query "SELECT descrizione, categoria_id FROM categoriaevento" {
	set esame_url [export_vars -base "test-prepara" {utente_id categoria_id}]
    }
