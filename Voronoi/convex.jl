mutable struct segmento
    punto1::Array
    punto2::Array
end

function dibujar_puntos(puntos, puntos_convex)
    
    n = length(puntos)
    
    xs = zeros(n+1)
    ys = zeros(n+1)
    
    for i in 1:n
        xs[i] = puntos_convex[i][1]
        ys[i] = puntos_convex[i][2]
    end
    
    xs[n+1] = vs[1][1]
    ys[n+1] = vs[1][2]
    
    grafica = plot(xs, ys, aspect_ratio = 1, legend = false)
    grafica = scatter!(xs, ys, aspect_ratio = 1, markersize = 3, legend = false)
    
    return grafica
    
end

function segmento_recta(puntos)
    
    """
    Esta función me sirve para graficar los segmentos.
    """
    
    x1 = puntos[1][1]
    y1 = puntos[1][2]
    
    x2 = puntos[2][1]
    y2 = puntos[2][2]
    
    m = (y1-y2)/(x1-x2)
    b = (y2*x1 - y1*x2)/(x1 - x2)
    
    xi = min(x1, x2)
    xf = max(x1, x2)
    
    xs = range(xi, stop = xf, length = 100)
    ys = [m*x + b for x in xs]
    
    return xs, ys

end  

function segmento_recta(segment::segmento)
    
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
    
    xs = range(xi, stop = xf, length = 100)
    ys = [m*x + b for x in xs]
    
    return xs, ys

end   

function distancia_2D(x::Array,y::Array)
    return sqrt((x[1]-y[1])^2 + (x[2]-y[2])^2)
end

mutable struct extremos
    arriba::Array
    abajo::Array
    izquierda::Array
    derecha::Array
end

function vertices_extremos(puntos)
    
    n = length(puntos)
    
    sort!(puntos, by = x-> x[2], rev = true) # del que está más arriba al más abajo
    
    arriba = puntos[1]
    abajo = puntos[n]
    
    sort!(puntos, by = x-> x[1]) # del que está más a la izquierda a más a la derecha
    
    izquierda = puntos[1]
    derecha = puntos[n]
     
    return extremos(arriba, abajo, izquierda, derecha)    

end

function ordenar_por_angulo(puntos::Array)
    
    n = length(puntos)
    aux = []
    
    P0 = vertices_extremos(puntos).abajo # punto más abajo
    
    for i in 1:n
        Pi = puntos[i]
        θ = atan(Pi[2]-P0[2], Pi[1]-P0[1])  # atan(y,x), la función así ya se encarga de la ambigüedad que
                                            # puede haber en el atan, por eso la ponemos así en vez de atan(y/x)
        
        push!(aux, [θ, puntos[i]])
    end
    
    sort!(aux, by = x -> x[1]) # lo ordenamos por el ángulo, de menor a mayor (el primero es entonces P0)
    
    ordenados = []
    
    for i in 1:n
        push!(ordenados, aux[i][2])
    end
    
    return ordenados
    
end

function cross2(P1,P2)
    return P1[1]*P2[2] - P2[1]*P1[2]
end

function CCW(P1,P2,P3)
    """
    Esta función nos determina si los puntos van a la izquierda (sentido contrario de las manecillas
    del reloj o CCW) o a la derecha (CW).
    """
    
    P2_3 = P3-P2
    P1_3 = P3-P1
    
    s = cross2(P1_3, P2_3)
    
    if sign(s) > 0
        return true
    else
        return false
    end
    
end

function convex_graham(puntos::Array)
    
    n = length(puntos)
    vertices_convex = []
       
    puntos_orden = ordenar_por_angulo(puntos)
    aux = [puntos_orden[i] for i in 1:n]
    
    P0 = puntos_orden[1]
    P1 = puntos_orden[2]
    P2 = puntos_orden[3]   
    
    push!(vertices_convex, P0) # pertenece al convex hull
    push!(vertices_convex, P1) # pertenece al convex hull
    push!(vertices_convex, P2)
    
    
    for i in 4:n
                        
        while true
                   
            k = length(vertices_convex)
            
            punto = puntos_orden[i]

            top = vertices_convex[k]
            next = vertices_convex[k-1] 

            if CCW(next,top,punto) == true
                break
            else
                #pop!(vertices_convex)
                deleteat!(vertices_convex, k)
            end  
                    
        end  
        
        push!(vertices_convex, puntos_orden[i])
                       
    end
    
    push!(vertices_convex, P0) # le agregamos el primer punto al final para que cierre el convex
    
    return vertices_convex
    
end

function dibujar_convex(puntos, puntos_convex)
    
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
        
    grafica = scatter(xs, ys, aspect_ratio = 1, markersize = 1, legend = false, color = "blue")
    grafica = scatter!(xs_convex, ys_convex, markersize = 3, color = "orangered")
    grafica = plot!(xs_convex, ys_convex, markersize = 3, color = "orangered")
    
    return grafica
    
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


;
