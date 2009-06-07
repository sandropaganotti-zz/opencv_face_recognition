require 'rubygems'
require 'opencv'

face_detectors = %w(
  /usr/local/share/opencv/haarcascades/haarcascade_frontalface_default.xml
).collect { |fd| OpenCV::CvHaarClassifierCascade::load(fd) }


file_names =  Dir.glob(ARGV[0] || "/Users/sandro/Ruby/image_labs/lib/facer/euruko2/*.jpg") 

file_names.each_with_index do |file_name,i|
  
  face_rectangles = []
  opencv_load = OpenCV::IplImage.load(file_name) 
  face_detectors.each_with_index do |face_detector,k|
    face_detector.detect_objects(opencv_load).each do |rect|
      face_rectangles << [ 
        rect.top_left.x,      rect.top_left.y,  
        rect.top_right.x    - rect.top_left.x,  
        rect.bottom_left.y  - rect.top_left.y 
      ]
    end
  end

  File.open("#{File.basename(file_name)}.html","w") do |file|
    file.write <<-HTML
      <html>
        <body style="margin:0px; background: url('file://#{file_name}') no-repeat top left;">
          #{  face_rectangles.collect do |(x,y,w,h)|
                "<div class=\"face\" style=\"position: absolute; left: #{x}px; 
                  top: #{y}px; width: #{w}px; height: #{h}px; border: 2px solid red; \"></div>"
              end.join("\n") }
        </body>
      </html>
    HTML
  end
  
  puts "End #{file_name}"

end

