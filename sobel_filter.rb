require 'chunky_png'

class ChunkyPNG::Image
  def at(x,y)
    ChunkyPNG::Color.to_grayscale_bytes(self[x,y]).first
  end
end

module SobelManipulator
  SOBEL_DX = [[-1,0,1],
                 [-2,0,2],
                 [-1,0,1]]

  SOBEL_DY = [[-1,-2,-1],
                 [0,0,0],
                 [1,2,1]]

  def self.generate_edges(image)
    borda = gerar_imagem_crua(image.width, image.height)
    borda_dx = gerar_imagem_crua(image.width, image.height)
    borda_dy = gerar_imagem_crua(image.width, image.height)

    for x in 1..image.width-2
      for y in 1..image.height-2
        pixel_x = filtrar(image, SOBEL_DX, x, y)
        pixel_y = filtrar(image, SOBEL_DY, x, y)

        val = calcular_desvio(pixel_x: pixel_x, pixel_y: pixel_y)
        borda[x,y] = ChunkyPNG::Color.grayscale(reforcar_borda(val))

        val_x = calcular_desvio(pixel_x: pixel_x)
        borda_dx[x,y] = ChunkyPNG::Color.grayscale(reforcar_borda(val_x))

        val_y = calcular_desvio(pixel_y: pixel_y)
        borda_dy[x,y] = ChunkyPNG::Color.grayscale(reforcar_borda(val_y))

      end
    end

    borda.save('final_edge.png')
    borda_dx.save('final-dx_edge.png')
    borda_dy.save('final-dy_edge.png')
  end

  private

  def self.gerar_imagem_crua(width, height)
    ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
  end

  def self.reforcar_borda(pixel)
    pixel = 255 if pixel > 255
    pixel
  end

  def self.calcular_desvio(params={})
    if params[:pixel_x] and params[:pixel_y]
      Math.sqrt((params[:pixel_x] * params[:pixel_x]) + (params[:pixel_y] * params[:pixel_y])).ceil
    elsif params[:pixel_x]
      Math.sqrt((params[:pixel_x] * params[:pixel_x])).ceil
    else params[:pixel_y]
      Math.sqrt((params[:pixel_y] * params[:pixel_y])).ceil
    end
  end

  def self.filtrar(image, matriz_de_mascara, x, y)
    pixel_x = (matriz_de_mascara[0][0] * image.at(x-1, y-1)) + (matriz_de_mascara[0][1] * image.at(x, y-1)) + (matriz_de_mascara[0][2] * image.at(x+1, y-1)) +
        (matriz_de_mascara[1][0] * image.at(x-1, y)) + (matriz_de_mascara[1][1] * image.at(x, y)) + (matriz_de_mascara[1][2] * image.at(x+1, y)) +
        (matriz_de_mascara[2][0] * image.at(x-1, y+1)) + (matriz_de_mascara[2][1] * image.at(x, y+1)) + (matriz_de_mascara[2][2] * image.at(x+1, y+1))
  end
end

img = ChunkyPNG::Image.from_file('images.png')
SobelManipulator.generate_edges(img)