#encoding=utf-8

from utils import cal_zoom, marker_cluster

def run():
    lat = 39.980491
    lon = 116.284688
    img_width = 616.0
    img_height = 348.0
    locations = []
    for i in range(6):
        locations.append((lat, lon - 0.07 * i))

    print "-" * 50, "before merge", "-" * 50
    markers = []
    for tem in locations:
        marker = "markers=label:1|%f%%2C%f" % (tem[0], tem[1])
        markers.append(marker)
    _map_url = "http://maps.google.com/maps/api/staticmap?%s&size=%dx%d&sensor=false" % ("&".join(markers), img_width, img_height)
    print _map_url

    zoom = cal_zoom(img_width, img_height, locations) 
    cluster = marker_cluster(locations, zoom, 30)
    markers = []
    for tem in cluster:
        marker = "markers=label:%d%%7C%f%%2C%f" % (tem[2], tem[0], tem[1])
        markers.append(marker)

    print "-" * 50, "\033[91mafter merge\033[0m", "-" * 50 
    map_url = "http://maps.google.com/maps/api/staticmap?%s&size=%dx%d&sensor=false" % ("&".join(markers), img_width, img_height)
    print map_url



if __name__ == '__main__':
    run()
