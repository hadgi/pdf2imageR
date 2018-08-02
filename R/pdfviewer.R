#' View PDF
#'
#' Renders pdf files as images in RStudio
#' @export


# Initialize ####

libs <- c("pdftools", "magick", "miniUI", "shiny")
lapply(libs, require, character.only = T)


# UI ####
pdfViewerAddin <- function() {

  ui <- miniPage(
    gadgetTitleBar("PDF2image Viewer"),

    miniContentPanel(
      fileInput(
        "file_id",
        "Select PDF file",
        multiple = FALSE,
        buttonLabel = "Browse...",
        placeholder = "No file selected"
      ),

      sliderInput(
        "w_pix",
        "Select width",
        200,
        1000,
        value = 400,
        step = 10
      ),

      uiOutput("jump"),

      uiOutput("pagetext"),

      uiOutput("navbuttons"),

      hr(),

      imageOutput("page")

    )
  )

  # Server ####

  server <- function(input, output, session) {

    options(shiny.maxRequestSize=30*1024^2) # bypass default size limit on uploads

    width_in <- reactive({
      input$w_pix
    }) # Width in px input

    pagecounter <-
      reactiveValues(pagevalue = 1) # Page counter initial value

    observeEvent(input$nex, {
      pagecounter$pagevalue <-
        pagecounter$pagevalue + 1     # Next - page counter
    })

    observeEvent(input$prv, {
      pagecounter$pagevalue <-
        pagecounter$pagevalue - 1  # Previous - page counter
    })

    observeEvent(input$nex2, {
      pagecounter$pagevalue <-
        pagecounter$pagevalue + 1     # Next - page counter
    })

    observeEvent(input$prv2, {
      pagecounter$pagevalue <-
        pagecounter$pagevalue - 1  # Previous - page counter
    })

    observeEvent(input$jump, {
      if (input$jump != pagecounter$pagevalue) {
        pagecounter$pagevalue <-
          as.integer(input$jump)  # Actual page - page counter

      }
    })

    totpages <- renderText({
      req(input$file_id)

      pdf_info(input$file_id$datapath)$pages

    })





    output$jump <- renderUI({
      req(input$file_id)
      selectInput(
        "jump",
        "Page:",
        choices = seq(1:totpages()),
        selected = pagecounter$pagevalue
      )
    })



    output$pagetext <- renderUI({
      HTML(paste("out of", totpages()))
    })


    output$navbuttons <- renderUI({
      req(input$file_id)

      tagList(actionButton("prv", "Previous page"),

              actionButton("nex", "Next page"))
    })


    output$page <- renderImage({
      req(input$file_id)
      req(pagecounter$pagevalue > 0)

      infile <-
        image_read_pdf(input$file_id$datapath, pages = pagecounter$pagevalue)

      outfile <-
        image_write(infile, tempfile(fileext = 'png'), format = 'png')

      list(src = outfile,
           contentType = 'image/png',
           width = width_in())

    }, deleteFile = TRUE)



    observeEvent(input$done, {
      stopApp(TRUE)
    })
  }


  runGadget(shinyApp(ui, server), viewer = paneViewer())
}

