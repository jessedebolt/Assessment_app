# Server logic
function(input, output) {
  
  # Reactive variable to store student data
  students <- reactiveVal(data.frame(Name = character(), stringsAsFactors = FALSE))
  
  # Add new student name using the visible button
  observeEvent(input$add_btn, {
    current_data <- students()
    
    # Create a new row with the same structure as the current data
    new_row <- data.frame(matrix(ncol = ncol(current_data), nrow = 1))
    colnames(new_row) <- colnames(current_data)
    
    # Fill in the name for the new student
    new_row$Name <- input$name_input
    
    # Add the new row to the current data
    students(rbind(current_data, new_row))
  }, ignoreInit = TRUE)
  
  # Add new student name using the hidden button (triggered by Enter key)
  observeEvent(input$hidden_add_btn, {
    current_data <- students()
    
    # Create a new row with the same structure as the current data
    new_row <- data.frame(matrix(ncol = ncol(current_data), nrow = 1))
    colnames(new_row) <- colnames(current_data)
    
    # Fill in the name for the new student
    new_row$Name <- input$name_input
    
    # Add the new row to the current data
    students(rbind(current_data, new_row))
  }, ignoreInit = TRUE)
  
  # Remove selected student name
  observeEvent(input$remove_btn, {
    current_data <- students()
    selected_row <- input$students_table_rows_selected
    if(!is.null(selected_row)) {
      current_data <- current_data[-selected_row, ]
      
      # If after removing, the data is empty, maintain the structure
      if(nrow(current_data) == 0) {
        current_data <- data.frame(Name = character(), stringsAsFactors = FALSE)
      }
      
      students(current_data)
    }
  })
  
  # Add new grade category using the visible button
  observeEvent(input$add_grade, {
    current_data <- students()
    if (input$grade_category != "" && !input$grade_category %in% colnames(current_data)) {
      current_data[, input$grade_category] <- NA
      students(current_data)
    }
  }, ignoreInit = TRUE)
  
  # Add new grade category using the hidden button (triggered by Enter key)
  observeEvent(input$hidden_add_grade, {
    current_data <- students()
    if (input$grade_category != "" && !input$grade_category %in% colnames(current_data)) {
      current_data[, input$grade_category] <- NA
      students(current_data)
    }
  }, ignoreInit = TRUE)
  
  observeEvent(input$students_table_cell_edit, {
    info <- input$students_table_cell_edit
    str(info)
    edited_data <- students()
    
    # Update the modified cell
    edited_data[info$row, info$col] <- info$value
    
    students(edited_data)
  })
  
  # Render the table
  output$students_table <- DT::renderDataTable({
    DT::datatable(students(), editable = TRUE)
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(students(), file, row.names = FALSE)
    },
    contentType = "text/csv"
  )
  
  observe({
    inFile <- input$file_upload
    if (is.null(inFile)) return(NULL)  # No file uploaded
    
    uploaded_data <- read.csv(inFile$datapath, stringsAsFactors = FALSE)
    students(uploaded_data)
  })
}
