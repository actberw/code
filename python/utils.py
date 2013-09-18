import math
OFFSET=268435456
RADIUS=85445659.4471

def lon_to_x(lon):
    return round(OFFSET + 
           RADIUS * lon * math.pi / 180)

def lat_to_y(lat):
   return round(OFFSET - RADIUS *
                math.log((1 + math.sin(lat * math.pi / 180)) / 
                (1 - math.sin(lat * math.pi / 180))) / 2) 

def pixel_distance(lat1, lon1, lat2, lon2, zoom):
    x1 = lon_to_x(lon1)
    y1 = lat_to_y(lat1)

    x2 = lon_to_x(lon2)
    y2 = lat_to_y(lat2)
    return int(round(math.sqrt(pow((x1 - x2),2) + pow((y1 - y2), 2)))) >> (21 - zoom)

def cal_zoom(img_width, img_height, locations):

    lats, lons = zip(*locations)

    min_lon = min(lons)
    max_lon = max(lons)

    min_lat = min(lats)
    max_lat = max(lats)

    angle1 = max(0.01, max_lon - min_lon)
    angle2 = max(0,01, max_lat - min_lat)
    GLOBE_WIDTH = 256.0

    zoom1 = int(round(math.log(img_width * 360 / angle1 / GLOBE_WIDTH) / math.log(2)))
    zoom2 = int(round(math.log(img_height * 360 / angle2 / GLOBE_WIDTH) / math.log(2)))
    return min(zoom1, zoom2)

def marker_cluster(locations, zoom, distance):
    result = []
    ex = []
    while (len(locations)):
        lat1, lon1 = locations.pop(0)
        if (lat1, lon1) in ex:
            continue
        else:
            ex.append((lat1, lon1))
        count = 1 
        for lat, lon in locations:
            if pixel_distance(lat1, lon1, lat, lon, zoom) < distance:
                count += 1
                ex.append((lat, lon)) 
        result.append((lat1, lon1, count))
    return result

