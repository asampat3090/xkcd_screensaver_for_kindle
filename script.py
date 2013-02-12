import Image, ImageDraw, ImageFont, urllib, re, os, math

destinationFolder = "/Users/asampat3090/Desktop/Programming/xkcd/Images" # Full path to destination folder. Needs to exist
# titleFile = open("/Users/asampat3090/Desktop/xkcd/TITLES",'w') # Full path of the file to store the titles in (doesn't have to exist. Will be overwritten if it does)
pattern = re.compile("img.*src=.*title=.*alt=.*")

nrComics = 449 # Number of comics to retrieve
for i in xrange(77, nrComics + 1):
    site = urllib.urlopen("http://www.xkcd.com/" + str(i) + "/") # Gets the site
    contentLine = None
    for line in site.readlines(): # Reads the source
        if pattern.search(line): #Looks for the line with the image stuff in it
            contentLine = line
            break
    
    # To deal with 404 "bug"
    if not contentLine:
        continue
    # print contentLine
    tokens = line.split('" ')
    #print tokens
    # account for links :(
    if tokens[0][0:2]=='<a':
        temp_tokens=tokens[0].split('><')
        print temp_tokens
        source = temp_tokens[1][len('img src="'):len(temp_tokens[1])] # Gets the url for the image
    else:
        source = tokens[0][len('<img src="'):len(tokens[0])] # Gets the url for the image
    title = tokens[1][len('title="'):len(tokens[1])] # The title-text (commonly known on these fora as the alt-text)
    alt = tokens[2][len('alt="'):len(tokens[2])] # The alt-text
    #print source
    print "Comic %d found. downloading..." % i
    # add initial zeros to numbers to have them in proper order
    numstr=str(i)
    if len(numstr)<3: 
        for j in xrange(0,3-len(numstr)):
            numstr="0" + numstr
    
    img_name = numstr + "_" + alt
    urllib.urlretrieve(source, os.path.join(destinationFolder, img_name + ".gif")) # Downloads the image
    # Expand image to cover the largest possible area
    # First create a canvas
    canvas_img=Image.new('RGB',(600,800),(255,255,255))
    
    copied=0

    img_full_name = img_name + ".gif"
    xkcd_img = Image.open("Images/" + img_full_name)
    # determine which orientation is best for comic and paste accordingly
    # xkcd_img.show()
    if xkcd_img.size[0]>xkcd_img.size[1]:
        temp_1=xkcd_img.rotate(90)
        # temp_1.show()
        temp_1.save("Images/"+img_full_name)
        # resize the image to fit the screen while maintaining the aspect ratio.
        new_to_old_ratio=float(775)/float(temp_1.size[1])
        if temp_1.size[0]*new_to_old_ratio>600:
            temp_2=temp_1.resize((600,int(math.floor(float(temp_1.size[1]*600)/float(temp_1.size[0])))))
            
            temp_2.save("Images/"+img_full_name)
            
            # now paste this temp2 to the 600x800 canvas
            canvas_img.paste(temp_2,(0,25+int(float(775-float(temp_1.size[1]*600)/float(temp_1.size[0]))/float(2))))
            
            canvas_img.save("Images/"+img_full_name)
            print 1
        else:
            temp_2=temp_1.resize((int(math.floor(float(temp_1.size[0])*new_to_old_ratio)),775))
            temp_2.save("Images/"+img_full_name)
            # temp_2.show()
            # now paste this temp2 to the 600x800 canvas
            canvas_img.paste(temp_2,(int(float(600-float(temp_1.size[0])*new_to_old_ratio)/float(2)),25))
            canvas_img.save("Images/"+img_full_name)
            print 2
         
    else:
        # resize the image to fit the screen while maintaining aspect ratio.
        new_to_old_ratio=float(600)/float(xkcd_img.size[0])
        print new_to_old_ratio
        if xkcd_img.size[1]*new_to_old_ratio>775:
    
            temp_2=xkcd_img.resize((int(math.floor(float(xkcd_img.size[0])*float(775))/float(xkcd_img.size[1])),775))
            temp_2.save("Images/"+img_full_name)
            #temp_2.show() 
            # now paste this temp2 to the 600x800 canvas
            canvas_img.paste(temp_2,(int(float(600-float(xkcd_img.size[0]*775)/float(xkcd_img.size[1]))/float(2)),25))
            canvas_img.save("Images/"+img_full_name)
            print 3
        else:
            temp_2=xkcd_img.resize((600,int(math.floor(float(xkcd_img.size[1])*new_to_old_ratio))))
            temp_2.save("Images/"+img_full_name)
            print xkcd_img.size
            print new_to_old_ratio
            print temp_2.size
            # now paste this temp2 to the 600x800 canvas
            canvas_img.paste(temp_2,(0,25+int(float(775-float(xkcd_img.size[1])*new_to_old_ratio)/float(2))))
            canvas_img.save("Images/"+img_full_name)
            print 4
    
        
    
    # Add caption to image
    
    pathz = "/Users/asampat3090/Desktop/Programming/xkcd/Images/" + img_full_name
    if os.path.exists(pathz):
        namez = img_full_name[:-4]
        d = ImageDraw.Draw(canvas_img)
        f = ImageFont.truetype("/Library/Fonts/Arial.ttf", 16)
        d.text((10, 10), namez, fill=0, font=f)
        canvas_img.save(pathz)
                        
    else:
        print "Directory not found"
