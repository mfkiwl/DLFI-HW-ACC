def cvt_int_to_hex(fdst, fsrc):
    fs = open(fsrc, 'r')
    fd = open(fdst, 'w')

    buf_src = []
    while True:
        line = fs.readline()
        if not line: break
        if(line != ''): buf_src.append(float(line))
    fs.close()

    for i in buf_src:
        hxd = format(int(i) & 0xff, '02x')
        line = fd.write(hxd + '\n')
    fd.close()

def fill_zeros(fname):
    fname_src = fname + '.txt'
    fname_dst = fname + '_zeros.txt'

    width = 3
    height = 3
    dilation = 3

    dw = int((width - 1) * (dilation - 1) + width)
    dh = int((height - 1) * (dilation - 1) + height)

    buf_src = []
    fs = open(fname_src, 'r')
    while True:
        line = fs.readline().rstrip()
        if not line: break
        if(line != ''): buf_src.append(str(line))
    fs.close()

    buf_dst = [[0 for _ in range(dh)] for __ in range(dw)]
    fd = open(fname_dst, 'w')
    for i in range(len(buf_src)):
        r = (i % (width * height)) // width
        c = (i % (width * height)) % width
        buf_dst[dilation * r][dilation * c] = buf_src[i]

        if((i % (width * height)) == width * height - 1):
            for j in buf_dst:
                for k in j:
                    # trick to cvt int->hex (signed & unsigned, whatever)
                    #hxd = format(k & 0xff, '02x')
                    #line = fd.write(hxd + '\n')
                    line = fd.write(str(k) + '\n')
    fd.close()

def split_into_each_pixel(fname_dst, fname_src, size):
    if fname_dst == '': fname_dst = fname_src
    dat = [[] for _ in range(size)]
    line = 0
    fs = open(fname_src, 'r')
    while True:
        val = fs.readline().rstrip()
        if not val: break
        if(val != ''): dat[line % size].append(str(val))
        line += 1
    fs.close()

    for i in range(size):
        fname = fname_dst + '_' + str(i) + '-pix.txt'
        fd = open(fname, 'w')
        for j in dat[i]:
            line = fd.write(str(j) + '\n')
        fd.close()

    return 0

fname_src = 'C:/Workspace/CIS/bottleneck/aspp3_w.txt'
fname_dst = 'C:/Workspace/CIS/bottleneck/wghts/aspp3_w.txt'
split_into_each_pixel(fname_dst, fname_src, 9)
#fname = 'C:/Workspace/CIS/bottleneck/aspp3_w_h'
#fill_zeros(fname)

