library(shiny)

# UI definition
fluidPage(
  tags$head(
    tags$script("
      $(document).ready(function() {
        $('#name_input').on('keyup', function(e) {
          if (e.key == 'Enter' || e.keyCode == 13) {
            e.preventDefault();  // Prevent any default behavior
            $('#hidden_add_btn').click();
          }
        });
        
        $('#grade_category').on('keyup', function(e) {
          if (e.key == 'Enter' || e.keyCode == 13) {
            e.preventDefault();  // Prevent any default behavior
            $('#hidden_add_grade').click();
          }
        });
      });
    ")
  ),
  
  titlePanel("Student Test Results"),
  
  sidebarLayout(
    sidebarPanel(
      tags$div(id = "name_container",
               textInput("name_input", "Enter Student Name"),
               actionButton("add_btn", "Add Name"),
               actionButton("hidden_add_btn", "", style = "display: none;")  # Hidden button
      ),
      
      tags$div(id = "grade_container",
               textInput("grade_category", "Add Grade Category"),
               actionButton("add_grade", "Add Category"),
               actionButton("hidden_add_grade", "", style = "display: none;")  # Hidden button
      ),
      
      actionButton("remove_btn", "Remove Selected Name")
    ),
    
    mainPanel(
      DT::dataTableOutput("students_table")
    )
  )
)
