
require 'chunky_png'

class ChunkyPNG::Image
  def at(x,y)
    ChunkyPNG::Color.to_grayscale_bytes(self[x,y]).first
  end
end

img = ChunkyPNG::Image.from_file('engine.png')

sobel_dx = [[-1,0,1],
            [-2,0,2],
            [-1,0,1]]

sobel_dy = [[-1,-2,-1],
            [0,0,0],
            [1,2,1]]

borda =    ChunkyPNG::Image.new(img.width, img.height, ChunkyPNG::Color::TRANSPARENT)
borda_dx = ChunkyPNG::Image.new(img.width, img.height, ChunkyPNG::Color::TRANSPARENT)
borda_dy = ChunkyPNG::Image.new(img.width, img.height, ChunkyPNG::Color::TRANSPARENT)

for x in 1..img.width-2
  for y in 1..img.height-2
    pixel_x = (sobel_dx[0][0] * img.at(x-1,y-1)) + (sobel_dx[0][1] * img.at(x,y-1)) + (sobel_dx[0][2] * img.at(x+1,y-1)) +
              (sobel_dx[1][0] * img.at(x-1,y))   + (sobel_dx[1][1] * img.at(x,y))   + (sobel_dx[1][2] * img.at(x+1,y)) +
              (sobel_dx[2][0] * img.at(x-1,y+1)) + (sobel_dx[2][1] * img.at(x,y+1)) + (sobel_dx[2][2] * img.at(x+1,y+1))

    pixel_y = (sobel_dy[0][0] * img.at(x-1,y-1)) + (sobel_dy[0][1] * img.at(x,y-1)) + (sobel_dy[0][2] * img.at(x+1,y-1)) +
              (sobel_dy[1][0] * img.at(x-1,y))   + (sobel_dy[1][1] * img.at(x,y))   + (sobel_dy[1][2] * img.at(x+1,y)) +
              (sobel_dy[2][0] * img.at(x-1,y+1)) + (sobel_dy[2][1] * img.at(x,y+1)) + (sobel_dy[2][2] * img.at(x+1,y+1))

    # método :ceil retorna o inteiro maior ou igual ao NUMBER de entrada, usado para normalizar
    val = Math.sqrt((pixel_x * pixel_x) + (pixel_y * pixel_y)).ceil
    val_x = Math.sqrt((pixel_x * pixel_x)).ceil
    val_y = Math.sqrt((pixel_y * pixel_y)).ceil
    #val = 255 if val > 255
    borda[x,y] = ChunkyPNG::Color.grayscale(val)
    borda_dx[x,y] = ChunkyPNG::Color.grayscale(val_x)
    borda_dy[x,y] = ChunkyPNG::Color.grayscale(val_y)
    #print "#{val}\t"
    mat_x[x,y] = pixel_x
  end
end

borda.save('final_edge.png')
borda_dx.save('final-dx_edge.png')
borda_dy.save('final-dy_edge.png')

print borda.pixels


