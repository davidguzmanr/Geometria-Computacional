mutable struct segmento
    punto1::Array
    punto2::Array
end

function dibujar_segmento(segment::segmento)
    
    """
    Esta función me sirve para graficar los segmentos.
    """
    
    x1 = segment.punto1[1]
    y1 = segment.punto1[2]
    
    x2 = segment.punto2[1]
    y2 = segment.punto2[2]
    
    m = (y1-y2)/(x1-x2)
    b = (y2*x1 - y1*x2)/(x1 - x2)
    
    xi = min(x1, x2)
    xf = max(x1, x2)
    
    xs = range(xi, stop = xf, length = 3)
    ys = [m*x + b for x in xs]

    #grafica = plot(xs, ys, color = "blue", label = "", aspect_ratio = 1)
    
    return xs, ys

end    

function interseccion(segmento1::segmento, m2::Number, b2::Number)
    
    """
    Esta función nos regresa la intersección de ambos segmentos si es es que existe.
    """
    
    # Para la primer recta
    
    x1_1 = segmento1.punto1[1]
    y1_1 = segmento1.punto1[2]
    
    x1_2 = segmento1.punto2[1]
    y1_2 = segmento1.punto2[2]
              
    if x1_1 == x1_2  # primer segmento vertical 
        
         x0 = x1_1
         y0 = m2*x0 + b2
        
         if (y0-y1_1)*(y0-y1_2) < 0 # ésto nos da una condición que nos dice si la intersección está en el segmento
             return [x0,y0]
         end
        
    elseif x1_1 != x1_2
        
        m1 = (y1_1-y1_2)/(x1_1-x1_2)
        b1 = (y1_2*x1_1 - y1_1*x1_2)/(x1_1 - x1_2)
        
        if m1 != m2 # segmentos no paralelos (y no verticales)
        
            x0 = (b2-b1)/(m1-m2)
            y0 = m1*x0 + b1

            if (x0-x1_1)*(x0-x1_2) < 0 # ésto nos da una condición que nos dice si la intersección está en el segmento
                return [x0,y0]
            end
	
        end
        
    end
                             
end


function interseccion(segmento1::segmento, segmento2::segmento)
    
    """
    Esta función nos regresa la intersección de ambos segmentos si es es que existe.
    """
    
    # Para la primer recta
    
    x1_1 = segmento1.punto1[1]
    y1_1 = segmento1.punto1[2]
    
    x1_2 = segmento1.punto2[1]
    y1_2 = segmento1.punto2[2]
    
    m1 = (y1_1-y1_2)/(x1_1-x1_2)
    b1 = (y1_2*x1_1 - y1_1*x1_2)/(x1_1 - x1_2)

    
    # Para la segunda recta
    
    x2_1 = segmento2.punto1[1]
    y2_1 = segmento2.punto1[2]
    
    x2_2 = segmento2.punto2[1]
    y2_2 = segmento2.punto2[2]
    
    m2 = (y2_1-y2_2)/(x2_1-x2_2)
    b2 = (y2_2*x2_1 - y2_1*x2_2)/(x2_1 - x2_2)

#     Al final de cuentas no era necesario lo comentado, sólo si quería considerar todos los casos
             
#     if x1_1 == x1_2 && x2_1 != x2_2 # primer segmento vertical y el segundo no vertical
        
#         x0 = x1_1
#         y0 = m2*x0 + b2
        
#         if (x0-x1_1)*(x0-x1_2) <= 0 && (x0-x2_1)*(x0-x2_2) <= 0# ésto nos da una condición que nos dice si la intersección está en los segmentos 
#             return [x0,y0]
#         end
        
#     elseif x2_1 == x2_2 && x1_1 != x1_1 # segundo segmento vertical y el primero no vertical
        
#         x0 = x2_1
#         y0 = m1*x0 + m1
        
#         if (x0-x1_1)*(x0-x1_2) <= 0 && (x0-x2_1)*(x0-x2_2) <= 0# ésto nos da una condición que nos dice si la intersección está en los segmentos 
#             return [x0,y0]
#         end
    
    if m1 != m2 # segmentos no paralelos (y no verticales)
        
        x0 = (b2-b1)/(m1-m2)
        y0 = m1*x0[1] + b1
        
        if (x0-x1_1)*(x0-x1_2) < 0 && (x0-x2_1)*(x0-x2_2) < 0# ésto nos da una condición que nos dice si la intersección está en los segmentos 
            return [x0,y0]
        end
        
    end
                
end



function poligono(n, r = 1, θ = 0.1)
    
    """
    Esta función nos genera los segmentos de un polígono de n lados
    """
    
    segmentos = []
    
    for i in 1:n
        
        l = segmento([r*cos(2π * (i-1)/n + θ), r*sin(2π * (i-1)/n + θ)], [r*cos(2π * i/n + θ), r*sin(2π * i/n + θ)])
        push!(segmentos, l)
    end
    
    return segmentos
       
end

function poligono_irregular(N, r = 1, θ = 0.1)
    
    segmentos = []
        
    αs = [rand(Uniform(0, 2π)) for i in 1:N]
    
    sort!(αs)
    
    push!(αs, αs[1])
    
    for i in 1:N
        l = segmento([r*cos(αs[i] + θ), r*sin(αs[i] + θ)], [r*cos(αs[i+1] + θ), r*sin(αs[i+1] + θ)])
        push!(segmentos, l)
    end
    
    return segmentos
    
end


function distancia_2D(x1::Array, x2::Array)
    return sqrt((x1[1]-x2[1])^2 + (x1[2]-x2[2])^2)
end


function interseccion_poligono_recta(poligono::Array, m::Number, b::Number)
    
    n = length(poligono)
    ints = []
    
    for i in 1:n
        
        x0 = interseccion(poligono[i], m, b)
        
        if isa(x0, Nothing) == false
            push!(ints, x0)
        end
        
    end
    
    seg_int = segmento(ints[1], ints[2])
    
    return seg_int
    
end

;
