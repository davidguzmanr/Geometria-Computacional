function get_max(puntos::Array)
    
    """
    Saca el máximo en x & y de un array de puntos.
    """
    
    n = length(puntos)
    
    xs = [puntos[i][1] for i in 1:n] 
    ys = [puntos[i][2] for i in 1:n] 
    
    x_max = maximum(xs) 
    y_max = maximum(ys)
    
    return x_max, y_max
    
end


function get_min(puntos::Array)
    
    """
    Saca el mínimo en x & y de un array de puntos.
    """
    
    n = length(puntos)
    
    xs = [puntos[i][1] for i in 1:n] 
    ys = [puntos[i][2] for i in 1:n] 
    
    x_min = minimum(xs) 
    y_min = minimum(ys)
    
    return x_min, y_min
    
end

function get_midpoint(puntos::Array)
    """
    Esta función es útilo para dividir los ṕuntos más o menos a la mitad a la hora de dividir en 
    cajitas en el divide y vencerás.
    """
    
    n = length(puntos)
    
    xs = [puntos[i][1] for i in 1:n] 
    
    x_media = sum(xs)/n
    
    return x_media
    
end

function separar_puntos(puntos::Array, x)
    
    """
    Esta función es para separar los puntos en cajas por medio de su coordenada en x, el número x
    es donde hacemos el corte.
    """
    
    n = length(puntos)
    
    izquierda = []
    derecha = []
    
    for i in 1:n
        if puntos[i][1] < x
            push!(izquierda, puntos[i])
        else
            push!(derecha, puntos[i])
        end
    end
    
    return izquierda, derecha
    
end

function distancia_punto_recta(m, b, punto::Array)
    
    x0 = punto[1]
    y0 = punto[2]
    
    d = abs(m*x0 - y0 + b)/(sqrt(m^2 + 1))
    
    return d
    
end

function borde_centros(segmentos::Array, centros::Array)
    
    """
    Esta función debería sacarme los respectivos segmentos de las regiones de Voronoi con sus 
    respectivos generadores.
    """
    
    bordes_con_centros = []
    
    for i in 1:length(segmentos)
        
        aux = []        
        distancias = []
        
        for j in 1:length(centros)
            m, b = recta_dos_puntos(segmentos[i].punto1, segmentos[i].punto2)
            d = distancia_punto_recta(m, b, centros[j])
            
            push!(aux, [d, centros[j]])
            
            #push!(distancias, [d, centros[j]])
        end
        
        sort!(aux, by = x -> x[1])
        
        push!(bordes_con_centros, [segmentos[i], aux[1][1], aux[1][2]])
            
#         sort!(distancias, by = x -> x[1])
        
#         @show distancias    
        
#         if abs(distancias[1][1] - distancias[2][1]) < 0.1
#             p1 = distancias[1][2]
#             p2 = distancias[2][2]
#             push!(bordes_con_centros, [segmentos[i], p1, p2])
#         end        
        
    end
    
    
    return bordes_con_centros
                
end


function borde_centros2(segmentos::Array, centros::Array)
    
    bordes_con_centros = []
    
    for i in 1:length(segmentos)
        
        aux = []        
        distancias = []
        
        for j in 1:length(centros)
            m, b = recta_dos_puntos(segmentos[i].punto1, segmentos[i].punto2)
            d = distancia_punto_recta(m, b, centros[j])
            
#             push!(aux, [d, centros[j]])
            
            push!(distancias, [d, centros[j]])
        end
        
#         sort!(aux, by = x -> x[1])
        
#         push!(bordes_con_centros, [segmentos[i], aux[1][1], aux[1][2]])
            
        sort!(distancias, by = x -> x[1])
        
        @show distancias    
        
        if abs(distancias[1][1] - distancias[2][1]) < 0.1
            p1 = distancias[1][2]
            p2 = distancias[2][2]
            push!(bordes_con_centros, [segmentos[i], p1, p2])
        end        
        
    end
    
    
    return bordes_con_centros
                
end


function is_lower(f, punto)
    
    x0 = punto[1]
    y0 = punto[2]
    
    if y0 < f(x0)
        return true
    else
        return false
    end
    
end

function is_upper(f, punto)
    
    x0 = punto[1]
    y0 = punto[2]
    
    if y0 > f(x0)
        return true
    else
        return false
    end
    
end

function recta_dos_puntos(punto1::Array, punto2::Array)
    
    x1 = punto1[1]
    y1 = punto1[2]
    
    x2 = punto2[1]
    y2 = punto2[2]
    
    m = (y1-y2)/(x1-x2)
    b = (y2*x1 - y1*x2)/(x1-x2)
    
    return m,b
    
end

function recta_pendiente_punto(m, punto::Array)
    
    x0 = punto[1]
    y0 = punto[2]
    
    #recta(x) = m*(x-x0) + y0 = m*x + (y0-m*x0)
    
    b = y0-m*x0
    
    return m, b
    
end

function ordenar_CW(puntos::Array, P0)
    
    puntos = unique!(puntos)
    
    n = length(puntos)
    aux_negativos = []
    aux_positivos = []
       
    for i in 1:n
        Pi = puntos[i]
        θ = atan(Pi[2]-P0[2], Pi[1]-P0[1])  # atan(y,x), la función así ya se encarga de la ambigüedad que
                                            # puede haber en el atan, por eso la ponemos así en vez de atan(y/x)
        if θ < 0.0
            push!(aux_negativos, [θ, puntos[i]])
        elseif θ > 0.0
            push!(aux_positivos, [θ, puntos[i]])
        end
    end
    
    sort!(aux_negativos, by = x -> x[1], rev = true) # lo ordenamos por el ángulo
    sort!(aux_positivos, by = x -> x[1], rev = true) # lo ordenamos por el ángulo

    
    ordenados = []
    
    push!(ordenados, P0)
    
    for i in 1:length(aux_negativos)
        push!(ordenados, aux_negativos[i][2])
    end
    
    for i in 1:length(aux_positivos)
        push!(ordenados, aux_positivos[i][2])
    end
    
    return ordenados
    
end

function ordenar_CW2(puntos::Array, P0)
    
    puntos = unique!(puntos)
    
    n = length(puntos)
    aux_negativos = []
    aux_positivos = []
       
    for i in 1:n
        Pi = puntos[i]
        θ = atan(Pi[2]-P0[2], Pi[1]-P0[1])  # atan(y,x), la función así ya se encarga de la ambigüedad que
                                            # puede haber en el atan, por eso la ponemos así en vez de atan(y/x)
        if θ < 0.0
            push!(aux_negativos, [θ, puntos[i]])
        elseif θ > 0.0
            push!(aux_positivos, [θ, puntos[i]])
        end
    end
    
    sort!(aux_negativos, by = x -> x[1], rev = true) # lo ordenamos por el ángulo
    sort!(aux_positivos, by = x -> x[1], rev = true) # lo ordenamos por el ángulo

    
    ordenados = []
    
    push!(ordenados, P0)
        
    for i in 1:length(aux_positivos)
        push!(ordenados, aux_positivos[i][2])
    end
    
    for i in 1:length(aux_negativos)
        push!(ordenados, aux_negativos[i][2])
    end
    
    return ordenados
    
end

function ordenar_CCW(puntos::Array, P0)
        
    n = length(puntos)
    aux_negativos = []
    aux_positivos = []
       
    for i in 1:n
        Pi = puntos[i]
        θ = atan(Pi[2]-P0[2], Pi[1]-P0[1])  # atan(y,x), la función así ya se encarga de la ambigüedad que
                                            # puede haber en el atan, por eso la ponemos así en vez de atan(y/x)
        if θ < 0.0
            push!(aux_negativos, [θ, puntos[i]])
        elseif θ > 0.0
            push!(aux_positivos, [θ, puntos[i]])
        end
    end
    
    sort!(aux_negativos, by = x -> x[1], rev = false) # lo ordenamos por el ángulo
    sort!(aux_positivos, by = x -> x[1], rev = false) # lo ordenamos por el ángulo

    
    ordenados = []
    
    push!(ordenados, P0)
    
    for i in 1:length(aux_negativos)
        push!(ordenados, aux_negativos[i][2])
    end
    
    for i in 1:length(aux_positivos)
        push!(ordenados, aux_positivos[i][2])
    end
    
    return unique!(ordenados)
    
end

function ordenar_CCW2(puntos::Array, P0)
        
    n = length(puntos)
    aux_negativos = []
    aux_positivos = []
       
    for i in 1:n
        Pi = puntos[i]
        θ = atan(Pi[2]-P0[2], Pi[1]-P0[1])  # atan(y,x), la función así ya se encarga de la ambigüedad que
                                            # puede haber en el atan, por eso la ponemos así en vez de atan(y/x)
        if θ < 0.0
            push!(aux_negativos, [θ, puntos[i]])
        elseif θ > 0.0
            push!(aux_positivos, [θ, puntos[i]])
        end
    end
    
    sort!(aux_negativos, by = x -> x[1], rev = false) # lo ordenamos por el ángulo
    sort!(aux_positivos, by = x -> x[1], rev = false) # lo ordenamos por el ángulo

    
    ordenados = []
    
    push!(ordenados, P0)
        
    for i in 1:length(aux_positivos)
        push!(ordenados, aux_positivos[i][2])
    end
    
    for i in 1:length(aux_negativos)
        push!(ordenados, aux_negativos[i][2])
    end
    
    return unique!(ordenados)
    
end

function dibujar_poligono(poligono::Array)
    
    grafica = plot(legend = false, aspect_ratio = 1)
    
    n = length(poligono)
    
    for i in 1:n
        xs = dibujar_segmento(poligono[i])[1]
        ys = dibujar_segmento(poligono[i])[2]
        
        grafica = plot!(xs, ys, color = "orangered", lw = 1)
    end
    
    vertices_x = []
    vertices_y = []
    
    for i in 1:n
        push!(vertices_x, poligono[i].punto1[1])
        push!(vertices_y, poligono[i].punto1[2])
    end
    
    grafica = scatter!(vertices_x, vertices_y, color = "red", markersize = 2)
    
    return grafica
    
end

function dibujar_convex!(grafica, puntos, puntos_convex)
    
    """
    Esta función es para graficar los puntos y el convex hull.
    """
    
    n = length(puntos)
    m = length(puntos_convex)
    
    xs = zeros(n)
    ys = zeros(n)
    
    xs_convex = zeros(m)
    ys_convex = zeros(m)
        
    for i in 1:n
        xs[i] = puntos[i][1]
        ys[i] = puntos[i][2]
    end
    
    for i in 1:m
        xs_convex[i] = puntos_convex[i][1]
        ys_convex[i] = puntos_convex[i][2]
    end
        
    grafica = scatter!(xs, ys, aspect_ratio = 1, markersize = 1, legend = false, color = "blue")
    grafica = scatter!(xs_convex, ys_convex, markersize = 3, color = "orangered")
    grafica = plot!(xs_convex, ys_convex, markersize = 3, color = "orangered")
    
    return grafica
    
end

function dibujar_voronoi_divide!(grafica, regiones::Array, caja)

    colores = [rand(3) for i in 1:1000] 
    
    c0 = rand(1:1000)
        
    for i in 1:length(regiones)
        
        region_i = regiones[i]
        
        for j in 1:length(region_i)
            xs = dibujar_segmento(region_i[j])[1]
            ys = dibujar_segmento(region_i[j])[2]
            
#             xs′ = []
#             ys′ = []
            
#             for k in 1:length(xs)
#                 if xs[k] <= 10^3 && ys[k] <= 10^3
#                     push!(xs′, xs[k])
#                     push!(ys′, ys[k])
#                 end
#             end
            
            #grafica = plot!(xs′, ys′, lw = 1, color = RGB(colores[c0][1], colores[c0][2], colores[c0][3]))
            grafica = plot!(xs, ys, lw = 1, color = RGB(colores[c0][1], colores[c0][2], colores[c0][3]))

        end
        
    end
    
    for i in 1:length(caja)
        xs = dibujar_segmento(caja[i])[1]
        ys = dibujar_segmento(caja[i])[2]
        grafica = plot!(xs, ys, color = "orangered", lw = 2)
    end
    
    return grafica
end

function edge_two_nearest_points(linea::segmento, centros::Array)
    
    """
    Esta función me saca el borde del diagrama de Voronoi con sus dos generadores
    """
    
    # OBSERVACIÓN: EN ESTA FUNCIÓN PARECE ESTAR EL ERROR Y POR ESO LA CADENA NO ME SALE SIEMPRE
    
    # Observación de la observación: ya lo corregí.
    
    distancias = []
    
    x1 = linea.punto1[1]
    y1 = linea.punto1[2]
    
    x2 = linea.punto2[1]
    y2 = linea.punto2[2]
    
    for i in 1:length(centros)
        
        P1Q = centros[i] - linea.punto1
        P1P2 = linea.punto2 - linea.punto1
        
        t = (P1P2⋅P1Q)/(P1P2⋅P1P2)
        
        m,b = recta_dos_puntos(linea.punto1, linea.punto2)
        
        # La proyección del punto se encuentra sobre el segmento        
        if t >= 0 && t <= 1
            d = distancia_punto_recta(m, b, centros[i])
            push!(distancias, [d, centros[i]])
        # En caso contrario la proyección del punto no está sobre el segmento
        else
            d1 = distancia_2D(centros[i], linea.punto1)
            d2 = distancia_2D(centros[i], linea.punto2)
            d = min(d1, d2)
            push!(distancias, [d, centros[i]])
        end
              
    end
    
    sort!(distancias, by = x -> x[1])
    
    #display(distancias)
       
    for i in 1:length(distancias)
        
        for j in 1:length(distancias)
            
            if i != j
                # Parece haber un error numérico y por eso lo pongo así
                if distancias[i][1]/distancias[j][1] < 1.1 && distancias[i][1]/distancias[j][1] > 0.9
                #if distancias[i][1] == distancias[j][1]

                P1P2 = linea.punto1 - linea.punto2
                Q1Q2 = distancias[i][2] - distancias[j][2]

                proyeccion = abs(P1P2⋅Q1Q2)

                #println("$(proyeccion)")

                if proyeccion < 10.0^(-4)
                    two_nearest = [linea, distancias[i][2], distancias[j][2]]
                    #println("LO ENCONTRAMOS")
                    return two_nearest
                    break
                end
                    
                end
            
            end
            
        end
    
    end
    
end

function next_generator(line, centros)
    
    """
    Esta función me regresa el otro generador que debemos tomar al encontrar la cadena que une
    los dos Voronoi.
    """
    
    results = edge_two_nearest_points(line, centros)
    
    if isa(results, Nothing) == false
        edge = results[1]
        p1 = results[2]
        p2 = results[3]

        if p1[2] > p2[2]
            return p1
        elseif p2[2] > p1[2]
            return p2
        end 
    end
    
    
end


function dibujar_voronoi_divide_gif!(grafica, regiones::Array, caja, colors)

    colores = [rand(3) for i in 1:1000] 
    
    c0 = rand(1:1000)
        
    for i in 1:length(regiones)
        
        region_i = regiones[i]
        
        for j in 1:length(region_i)
            xs = dibujar_segmento(region_i[j])[1]
            ys = dibujar_segmento(region_i[j])[2]
            
#             xs′ = []
#             ys′ = []
            
#             for k in 1:length(xs)
#                 if xs[k] <= 10^3 && ys[k] <= 10^3
#                     push!(xs′, xs[k])
#                     push!(ys′, ys[k])
#                 end
#             end
            
            #grafica = plot!(xs′, ys′, lw = 1, color = RGB(colores[c0][1], colores[c0][2], colores[c0][3]))
            grafica = plot!(xs, ys, lw = 1, color = colors)

        end
        
    end
    
    for i in 1:length(caja)
        xs = dibujar_segmento(caja[i])[1]
        ys = dibujar_segmento(caja[i])[2]
        grafica = plot!(xs, ys, color = "orangered", lw = 2)
    end        
    
    return grafica
end


function dibujar_voronoi_divide_gif2!(grafica, regiones::Array, caja, colors)

    colores = [rand(3) for i in 1:1000] 
    
    c0 = rand(1:1000)
    
    for i in 1:length(regiones)
        xs, ys = dibujar_segmento(regiones[i])
        grafica = plot!(xs, ys, lw = 1, color = colors)
    end
    
    
    for i in 1:length(caja)
        xs = dibujar_segmento(caja[i])[1]
        ys = dibujar_segmento(caja[i])[2]
        grafica = plot!(xs, ys, color = "orangered", lw = 2)
    end        
    
    return grafica
end

;
