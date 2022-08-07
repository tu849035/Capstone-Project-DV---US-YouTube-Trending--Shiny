function(input, output) {
  # --------- HALAMAN PERTAMA: OVERVIEW
  output$barplot1 <- renderPlotly({
    # ggplot
    plot1 <- vids_count %>% 
      ggplot(aes(x = count,
                 y = reorder(category_id, count),
                 fill = count,
                 text = label)) +
      geom_col() +
      scale_fill_gradient(low = "red", high = "black") +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(title = NULL,
           x = 'Video Count',
           y = NULL)
    # plotly
    ggplotly(plot1, tooltip = "text")
  })
  output$barplot2 <- renderPlotly({
    # ggplot
    plot1 <- vids_count %>% 
      ggplot(aes(x = count,
                 y = reorder(category_id, count),
                 fill = count,
                 text = label)) +
      geom_col() +
      scale_fill_gradient(low = "red", high = "black") +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(title = NULL,
           x = 'Video Count',
           y = NULL)
    # plotly
    ggplotly(plot1, tooltip = "text")
  })
  # --------- HALAMAN KEDUA: CHANNELS
  output$lollipop <- renderPlotly({
    vids_top_channel <- vids_clean %>% 
      #mengubah input filter sesuai dengan input user
      filter(category_id == input$input_category) %>% # (GANTI DI SINI)
      group_by(channel_title) %>% 
      summarise(sum_views = sum(views)) %>% 
      arrange(desc(sum_views))
    # data 
    vids_10 <- vids_top_channel %>% 
      mutate(label = glue("Channel: {channel_title}
                      Sum Views: {scales::comma(sum_views)}")) %>% 
      head(10)
    # ggplot
    plot2 <- vids_10 %>% 
      ggplot(aes(x = sum_views,
                 y = reorder(channel_title, sum_views),
                 color = sum_views,
                 text = label)) +
      geom_point(size = 3) +
      geom_segment(aes(x = 0, xend = sum_views, yend = channel_title), size = 1) +
      labs(x = 'Total Views',
           y = NULL,
           #mengubah title agar sesuai dengan input user
           title = glue("Top Channels in {input$input_category}")) + # (GANTI DI SINI)
      scale_color_gradient(low = "red", high = "black") +
      scale_x_continuous(labels = scales::comma) +
      #mengubah agar channel dengan nama yang panjang di-wrap kebawah
      scale_y_discrete(labels = function(x) str_wrap(x, width = 20)) + # (TAMBAHKAN DI SINI)
      theme_minimal() +
      theme(legend.position = "none",
            plot.margin = margin(r = 20))
    # plotly
    ggplotly(plot2, tooltip = "text")
  })
  output$lineplot <- renderPlotly({
    # data
    vids_trend <- vids_clean %>% 
      filter(category_id == input$input_category) %>% # (GANTI DI SINI)
      group_by(publish_hour) %>% 
      summarise(mean_views = mean(views)) %>% 
      ungroup() %>% # opsional, karena grouping hanya 1 kolom
      mutate(label = glue("Publish Hour: {publish_hour}
                      Average Views: {scales::comma(mean_views)}"))
    # ggplot
    plot3 <- vids_trend %>% 
      ggplot(aes(x = publish_hour, y = mean_views)) +
      geom_line(color = "red") +
      geom_point(aes(text = label)) +
      scale_y_continuous(labels = scales::comma) +
      labs(
        #mengubah judul agar berubah sesuai input kategori dari user
        title = glue("Viewers Activity in {input$input_category} Videos"), # (GANTI DI SINI)
        x = "Publish Hour",
        y = "Average Views"
      ) +
      theme_minimal()
    # plotly
    ggplotly(plot3, tooltip = "text")
  })
  # --------- HALAMAN KETIGA: DATA
  output$table <- renderDataTable({
    DT::datatable(vids_clean,
                  #argumen/parameter agar dataframe dapat discroll
                  options = list(scrollX = TRUE))
  })
}