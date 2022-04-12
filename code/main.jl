###################################################################################################################################################################
##############Packages##############################################################################################################################################
####################################################################################################################################################################
using GLMakie
include("SVDisplay.jl")
include("SVMesh.jl")

####################################################################################################################################################################
#######Variable Declerations########################################################################################################################################
####################################################################################################################################################################

#type holds the analysis type
type = Observable("Empty") 

#The following variables are holding the node and element information.
nodes = Observable(zeros(1,2))
node_edited = false
elements = Observable(zeros(Int64,1,2))
elements_edited = false

####################################################################################################################################################################
#############Code Body##############################################################################################################################################
####################################################################################################################################################################



#We start by displaying the main menu
display(SVDisplay.mainMenu)

#We wait for a selection to be made from the list
on(SVDisplay.menu_type.selection) do s
    global type
    type[] = s
    SVDisplay.typeselected(type)
end


#This part waits for the click to add the inputted coordinates
on(SVDisplay.button_coord.clicks) do n
    global nodes, node_edited
    temp_x = SVDisplay.xcoord[]
    temp_y = SVDisplay.ycoord[]
    if !node_edited
        nodes[] = [temp_x temp_y]
        node_edited = true
    else
        nodes[] = vcat(nodes[],[temp_x temp_y])
    end
    SVDisplay.changeNodes(nodes)
end


#This part waits for the click to add the inputted nodes
on(SVDisplay.button_node.clicks) do n
    global nodes, elements_edited
    temp_1 = SVDisplay.node1[]
    temp_2 = SVDisplay.node2[]
    if !elements_edited
        elements[] = [temp_1 temp_2]
        elements_edited = true
    else
        elements[] = vcat(elements[],[temp_1 temp_2])
    end
    SVDisplay.changeElements(elements)
end 