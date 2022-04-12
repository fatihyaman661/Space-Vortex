module SVMesh

mutable struct GlobalMesh
    #=
    This struct will hold the information about the global nodes and global elements. Element numbers etc.
    =#
    node::Array{Float64,2} 
    #=node array holds information about the location of the global nodes. The first dimension refers to the
    node number, and the second dimension refers to whether its x (1), y (2) or z(3) coordinate 
    =#
    force::Array{Float64,2}
    #=force array holds the information about the external forces applied on the system. The first dimension
    holds information about at which node the force is exerted. The second dimension holds the magnitude of the 
    force in x (1), y(2) and z(3) directions.
    =#
    GlobalMesh(node,force) = new(node,force)
end
GlobalMesh() = GlobalMesh([1 0],[1 0]) #This is the default method initializing with zeros

mutable struct Truss2d
    #=
    In this struct, the first dimension will refer to the element. 
    And the second dimension will refer to the local node of the element.
    =#
    node::Array{Int64,1} #This is the global node numbers
    disp::Array{Float64,2} #This is the displacement of the nodes 1 and 2, and in x and y directions
    stiffness::Float64 #This holds the information about the stiffness of the element
    force::Array{Float64,2} #This is the forces acting on the local nodes externally, nodes 1 and two. Second dimension is in x or y direction.
    stiff::Array{Float64,3} #This is the stiffness matrix of the element. Will be explained in more detail in the manual    

    function Truss2d(node, disp, stiffness, force)
        stiff = zeros(1,2,2)
        stiff[1,:,:] = [stiffness -stiffness ; -stiffness stiffness]
        return new(node, disp, stiffness, force, stiff)
    end


end
Truss2d() = Truss2d(zeros(2),zeros(2,2),0,zeros(2,2)) #This is the default method initializing with zeros

end
