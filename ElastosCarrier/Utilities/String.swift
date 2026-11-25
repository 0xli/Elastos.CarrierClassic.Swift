/*
 * Copyright (c) 2018 Elastos Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

internal extension String {

    static func toHardString(_ str: String?) -> String {
        if (str == nil) {
            return "<nil>"
        } else if (str == "") {
            return "<empty>"
        } else {
            return str!
        }
    }

    init<T>(cCharPointer pointer: UnsafePointer<T>) {
        self.init(cString: UnsafeRawPointer(pointer).assumingMemoryBound(to: CChar.self))
    }

    /// Copy into a fixed-size C char array field (`T` is the array's tuple
    /// type, so its size is the field's capacity). A string that does not fit
    /// is cut at a character boundary; the field is always terminated and
    /// nothing is written past it.
    @inline(__always) func writeToCCharPointer<T>(_ pointer : UnsafeMutablePointer<T>) {
        let capacity = MemoryLayout<T>.size
        guard capacity > 0 else { return }
        let dst = UnsafeMutableRawPointer(pointer).assumingMemoryBound(to: CChar.self)
        self.withCString({ src in
            var n = strlen(src)
            if n >= capacity {
                n = capacity - 1
                while n > 0 && (UInt8(bitPattern: src[n]) & 0xC0) == 0x80 {
                    n -= 1
                }
            }
            memcpy(dst, src, n)
            dst[n] = 0
        })
    }
}

@inline(__always) internal func createCStringDuplicate(_ field: String?) -> UnsafePointer<CChar>? {
    if field != nil {
        return UnsafePointer<CChar>(field!.withCString {
            return strdup($0)
        })
    } else {
        return nil
    }
}

@inline(__always) internal func deallocCString(_ field: UnsafePointer<CChar>?) {
    if (field != nil) {
        free(UnsafeMutablePointer<CChar>(mutating: field))
    }
}
