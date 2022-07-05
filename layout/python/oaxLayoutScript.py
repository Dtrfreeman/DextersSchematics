# convertion tool for LayoutScript and OpenAccess Script

import oa
import LayoutScript

def toRect(data):
    rec=LayoutScript.rect()
    if (isinstance(data, oa.oaBox)):
            rec.setTop(data.top())
            rec.setBottom(data.bottom())
            rec.setLeft(data.left())
            rec.setRight(data.right())
    else:
            print("cannot convert from "+str(type(data)))
    return rec

def toOaBox(data):
    rec=oa.oaBox()
    if (isinstance(data, LayoutScript.rect)):
            rec.set(data.left(),data.bottom(),data.right(),data.top())
    elif (isinstance(data, LayoutScript.pointArray)):
        left=data.point(0).x()
        right=data.point(0).x()
        top=data.point(0).y()
        bottom=data.point(0).y()
        for i in range (0, data.size()):
            if (data.point(i).x()<left): left=data.point(i).x()
            if (data.point(i).x()>right): right=data.point(i).x()
            if (data.point(i).y()>top): top=data.point(i).y()
            if (data.point(i).y()<bottom): bottom=data.point(i).y()
        rec.set(left,bottom,right,top)
    else:
            print("cannot convert from "+str(type(data)))
    return rec

def toOaPointArray(data):
    pa=oa.oaPointArray()
    if (isinstance(data, LayoutScript.pointArray)):
            size=data.size()
            if (data.point(0)==data.point(size-1)): size=size-1
            for i in range (0, size):
                    pa.append([data.point(i).x(),data.point(i).y()])
    else:
            print("cannot convert from "+str(type(data)))
    return pa

def toPointArray(data):
    pa=LayoutScript.pointArray()
    if (isinstance(data, oa.oaPointArray)):
            for point in data:
                    pa.attach(point.x(),point.y())
    elif (isinstance(data, oa.oaBox)):
            pa.attach(data.left(),data.top())
            pa.attach(data.left(),data.bottom())
            pa.attach(data.right(),data.bottom())
            pa.attach(data.right(),data.top())
            pa.attach(data.left(),data.top())
    else:
            print("cannot convert from "+str(type(data)))
    return pa




