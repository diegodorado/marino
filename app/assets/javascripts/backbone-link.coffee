$.extend($.fn,                                                                   
  backboneLink: (model) ->                                                       
    $form = this                                                                 
    $(this).find(':input').each ->                                               
      $el = $(this)                                                              
      name = $el.attr('name') 
      checkbox = $el.is ':checkbox'
      
      model.bind "change:#{name}", ->
        newVal =  model.get(name)                                              
        if checkbox
          $el.prop checked: not not newVal
        else
          $el.val newVal        
                                                                                 
      $el.on 'change', ->                                                        
        newVal = if checkbox then $el.prop 'checked' else $el.val()        
        model.set name, newVal                                              
)