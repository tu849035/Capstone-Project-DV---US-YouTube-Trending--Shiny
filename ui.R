dashboardPage(
  #argumen skin mengubah warna header menjadi merah
  skin = "red",
  dashboardHeader(title = "US YouTube Trending"),
  dashboardSidebar(
    sidebarMenu(
      #tabName digunakan untuk ID tiap menuItem. disambungkan ke tabItem pada dashboardBody()
      menuItem("Overview", tabName = "overview", icon = icon("video")),
      menuItem("Channels", tabName = "channels", icon = icon("youtube")),
      menuItem("Data", tabName = "data", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      # --------- HALAMAN PERTAMA: OVERVIEW
      tabItem(
        tabName = "overview",
        # --------- INFO BOXES
        fluidRow(
          infoBox("total unique videos", length(unique(vids_clean$title)), icon = icon("file-video")),
          infoBox("total unique channels", length(unique(vids_clean$channel_title)), icon = icon("circle-play"), color = "red"),
          infoBox("categories", length(unique(vids_clean$category_id)), icon = icon("photo-film"), color = "black")
        ),
        # --------- BAR PLOT
        fluidRow(
          box(
            width = 12,
            title = "Trending Categories on YouTube US 2017",
            plotlyOutput(outputId = "barplot")
          )
        )
      ),
      # --------- HALAMAN KEDUA: CHANNELS
      tabItem(
        tabName = "channels",
        # --------- INPUT
        fluidRow(
          box(
            width = 12,
            selectInput(
              inputId = "input_category", 
              label = "Choose Video Category", 
              choices = levels(vids_clean$category_id)
            )
          )
        ),
        # --------- PLOT
        fluidRow(
          # lollipop (kiri)
          # fungsi box tidak diberikan argumen title karena mengikuti title dari server
          box(
            plotlyOutput(outputId = "lollipop")
          ),
          # lineplot (kanan)
          box(
            plotlyOutput(outputId = "lineplot")
          )
        )
      ),
      # --------- HALAMAN KETIGA: DATA
      tabItem(
        tabName = "data",
        DT::dataTableOutput(outputId = "table")
      )
    )
  )
)