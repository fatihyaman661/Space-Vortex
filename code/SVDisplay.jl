module SVDisplay

using GLMakie
using PrettyTables


#################################################################################################################################################################
#########Main menu###############################################################################################################################################
#################################################################################################################################################################

#This is the figure of the main menu_type
mainMenu = Figure()

#this is the grid that will hold the list and its text in it
listGrid = mainMenu[1,1] = GridLayout()

#This is the list that has the analysis types and we select from.
menu_type = Menu(listGrid[2,1], options = ["2D Truss", "Deneme"], tellheight = false)

#this portion of the code is used for inserting the axis to hold the text, hiding its unnecessary decorations and writing the text on the axis.
#The extra arguements make sure the text is not moveable
axText = Axis(listGrid[1,1], xpanlock = true, ypanlock = true, xzoomlock = true, yzoomlock = true, xrectzoom = false, yrectzoom = false)
hidespines!(axText)
hidedecorations!(axText)
limits!(axText, 0, 1, 0, 1)
text!(axText, "Please select the analysis type...", position = (0,0))

#This line of code is added to make list and text stay in appropriate positions.s
rowsize!(mainMenu.layout, 1, Relative(1/6))

#This variable will hold the selected type. It is used for showing the selected type after a type is selected
selectedType = Observable("Empty")


#This function is called after a type is selected to show the sedcond version of the main menu showing the selected type and a button to go to
#analysis screen
function typeselected(type) 
    global selectedType

    #This is the grid to hold the button
    buttonGrid = mainMenu[2,1] = GridLayout()

    #I arrange the rowsize so that it i appropriate for the eye
    rowsize!(mainMenu.layout, 2, Relative(3/6))

    #this portion of the code is used for inserting the axis to hold the text, hiding its unnecessary decorations and writing the text on the axis.
    #The extra arguements make sure the text is not moveable    
    axText = Axis(buttonGrid[1,1], xpanlock = true, ypanlock = true, xzoomlock = true, yzoomlock = true, xrectzoom = false, yrectzoom = false)
    hidespines!(axText)
    hidedecorations!(axText)
    limits!(axText, 0, 1, -0.5, 1)
    
    #If this function is called for the first time, this part of the code is activated. This makes sure that the text and the button is 
    #printed just once. If I didn't add this if condition, everytime a new selection was made the text and the button bcame bolder due to 
    #overwrite.
    if selectedType[] == "Empty"
    global button_mesh
    text!(axText, lift(x -> string("Selected type is: ",selectedType[]),selectedType), position = (0,0))     
    button_mesh = Button(buttonGrid[2,1], label = "Click to proceed", tellwidth = false)
    end
  
    #I equate the type to the selected type after writing the text. But it doesnot make a difference since we have defined it as an obserable
    selectedType[] = type[]

    #This part is activated if the button is pressed.
    on(button_mesh.clicks) do n
        display(SVDisplay.Truss2DMenu)
    end      
end


#####################################################################################################################################################################
#########2DTruss menu################################################################################################################################################
#####################################################################################################################################################################

#This is the figure to hold the truss menu
Truss2DMenu = Figure()

#This part declares the grids and makes their sizes appropriate
buttonGrid = Truss2DMenu[1,1:2] = GridLayout()
axGrid = Truss2DMenu[2,1] = GridLayout()
listGrid = Truss2DMenu[2,2] = GridLayout()
colsize!(Truss2DMenu.layout, 1, Relative(3/5))

#This is the axis to holf the graph that holds the mesh.
axisOfMesh = Axis(axGrid[1,1], xlabel = "x", ylabel = "y")

#These observables hold the currently written x and y coordinates of the nodes. They are updated if there is an input to the textboxes.
xcoord = Observable(0.0)
ycoord = Observable(0.0)


#This part prints the textboxes and buttons for nodes to appropriate grids.
texBox_xcoord = Textbox(listGrid[1, 1], placeholder = "Enter x-coordinate", validator = Float64, tellheight = true, tellwidth = false)
texBox_ycoord = Textbox(listGrid[1, 2], placeholder = "Enter y-coordinate", validator = Float64, tellheight = true, tellwidth = false)
button_coord  = Button(listGrid[1,3], label = lift((x,y) -> "x:$(xcoord[]), y:$(ycoord[])",xcoord,ycoord) ,tellheight = true, tellwidth = false)

#Tis part is the part where the list of the nodes is shown. I have used the package prettyTables for this purpose. I give it the list of nodes,
#and it gives me a table string from it. Then I put that string on an axis in such a way that can be moved but not scaled.
axisOfTable1 = Axis(listGrid[2,:],xpanlock = false, ypanlock = false, xzoomlock = true, yzoomlock = true, xrectzoom = false, yrectzoom = false )
hidespines!(axisOfTable1)
hidedecorations!(axisOfTable1)
limits!(axisOfTable1, 0, 1, -0.5, 1)
coords = Observable([0.0 0.0])
table1 = lift( x -> pretty_table(String, hcat(collect(Float64,1:1:size(coords[],1)),coords[]), header = ["Node", "x-coordinate", "y-coordinate"]), coords )
text!(axisOfTable1, table1, position = (0,0), textsize = 15, font = "Consolas")

#This function is updated if the button is clicked after entering node coordinates through the textboxes.
function changeNodes(nodes)
    global coords
    coords[] = nodes[]
end

#The same thing is also done for the elements. It is exactly the same as written above, the only diffeerence is where the graph is drawn.
#I've put extra comment there.
node1 = Observable(Int(0))
node2 = Observable(Int(0))

texBox_node1 = Textbox(listGrid[3, 1], placeholder = "Enter first node", validator = Float64, tellheight = true, tellwidth = false)
texBox_node2 = Textbox(listGrid[3, 2], placeholder = "Enter second node", validator = Float64, tellheight = true, tellwidth = false)
button_node  = Button(listGrid[3,3], label = lift((x,y) -> "node1:$(node1[]), node2:$(node2[])",node1,node2),tellheight = true, tellwidth = false)

axisOfTable2 = Axis(listGrid[4,:],xpanlock = false, ypanlock = false, xzoomlock = true, yzoomlock = true, xrectzoom = false, yrectzoom = false )
hidespines!(axisOfTable2)
hidedecorations!(axisOfTable2)
limits!(axisOfTable2, 0, 1, -0.5, 1)

elem = Observable([0 0])
table2 = lift( x -> pretty_table(String, hcat(collect(Float64,1:1:size(elem[],1)),elem[]), header = ["Element", "1st node", "2nd node"]), elem )
text!(axisOfTable2, table2, position = (0,0), textsize = 15, font = "Consolas")

#Here when elements are updated I draw a graph of them
function changeElements(elements)
    global elem, coords
    elem[] = elements[]
    empty!(axisOfMesh)

    #I draw a seperate line and point for each element
    for i = 1:size(elem[], 1)
        lines!(axisOfMesh,[coords[][elem[][i],1];coords[][elem[][i,2],1]],[coords[][elem[][i],2];coords[][elem[][i,2],2]], color = :black)
        scatter!(axisOfMesh,[coords[][elem[][i],1];coords[][elem[][i,2],1]],[coords[][elem[][i],2];coords[][elem[][i,2],2]], color = :black)
    end


end



#This part updates the coordinates if something is inputted through the textbox
on(texBox_xcoord.stored_string) do s
    xcoord[] = parse(Float64, s)
end

on(texBox_ycoord.stored_string) do s
    ycoord[] = parse(Float64, s)
end


on(texBox_node1.stored_string) do s
    node1[] = parse(Int, s)
end

on(texBox_node2.stored_string) do s
    node2[] = parse(Int, s)
end


#This button changes the figure so that the boundary conditions are inputted
button_options = Button(buttonGrid[1,1], label = "Proceed to boundary Conditions", tellheight = true, tellwidth = false)


end
