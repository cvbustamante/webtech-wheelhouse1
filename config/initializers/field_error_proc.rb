# por defecto Rails envuelve un campo con error en un div.field_with_errors,
# lo cual rompe el layout de Bootstrap. Lo sacamos y usamos is-invalid a mano.
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag }
