$var = Get-WmiObject -Class win32_service -Filter "Name='VMUSBArbService'" 

Get-CimInstance -ClassName CIM_ServiceServiceDependency|

Where-Object {$_.Antecedent -match $var.Name} |                 
                
Select-Object @{n='Antecedent';e={$_.Antecedent.name}},
              @{n='Dependent';e={$_.Dependent.name}} 
      

$(Get-Date -date "01/01/0001").DayOfWeek