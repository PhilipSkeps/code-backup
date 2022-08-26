/* 
 * Blame: Philip Skeps
 * Class: BitVec
 * Date: 8/21/22
 * C++17
 * 
 */

#undef __cplusplus
#define __cplusplus 201703L

#ifndef __BIT_VEC__
#define __BIT_VEC__
#include <vector>
#include <stdexcept>

// std::vector<bool> is not conitguos this is a contiguos implementation
template<typename Unit>
class BitVec {
 private:

    class BitProxy {
     private:
        Unit* pUnit = nullptr;
        Unit Mask = 0b0; // maybe make this static and just have a 128 bit mask array
     public:
        constexpr BitProxy(const Unit *const pUnit, const uint_fast8_t &bitIndex) noexcept;
        operator bool() const noexcept;
        BitProxy &operator=(const BitProxy &Bit) noexcept;
        BitProxy &operator=(BitProxy &&Bit) noexcept;
        BitProxy &operator=(const bool &Bit) noexcept;
    };

    uint_fast8_t FreeBits;
    std::vector<Unit> DataVec;

    constexpr uint_fast8_t UnitBitSize = sizeof(Unit) * 8;
    constexpr std::size_t calculateRequiredByte(const std::size_t &size) noexcept;
    constexpr std::size_t calculateFreeBits(const std::size_t &size) noexcept;

 public:
    // ~~~CONSTRUCTORS~~~
    BitVec() : FreeBits(0), DataVec() {
        static_assert(std::is_integral_v<Unit>, "BitVec: Data Unit must be a IntegralType type");
    }
    BitVec(const std::size_t &size) : FreeBits(calculateFreeBits(size)), DataVec(calculateRequiredByte(size), 0) {
        static_assert(std::is_integral_v<Unit>, "BitVec: Data Unit must be a IntegralType type");
    }
    BitVec(const BitVec &RHS);
    BitVec(BitVec &&RHS);

    // ~~~DESTRUCTOR~~~
    ~BitVec();

    // ~~~EQUALITY OPERATORS~~~
    BitVec &operator=(const BitVec &RHS) noexcept;
    BitVec &operator=(BitVec &&RHS) noexcept;

    // ~~~LOGIC OPERATORS~~~
    bool operator< (const BitVec &RHS) const noexcept;
    bool operator> (const BitVec &RHS) const noexcept;
    bool operator<=(const BitVec &RHS) const noexcept;
    bool operator>=(const BitVec &RHS) const noexcept;
    bool operator==(const BitVec &RHS) const noexcept;
    bool operator!=(const BitVec &RHS) const noexcept;

    // ~~~BIT MANIP OPERATORS~~~
    BitVec &operator| (const BitVec &RHS) const;
    BitVec &operator& (const BitVec &RHS) const;
    BitVec &operator<<(const BitVec &RHS) const;
    BitVec &operator>>(const BitVec &RHS) const;
    BitVec &operator^ (const BitVec &RHS) const;

    BitVec &operator|= (const BitVec &RHS);
    BitVec &operator&= (const BitVec &RHS);
    BitVec &operator<<=(const BitVec &RHS);
    BitVec &operator>>=(const BitVec &RHS);
    BitVec &operator^= (const BitVec &RHS);

    BitVec &operator|= (BitVec &&RHS);
    BitVec &operator&= (BitVec &&RHS);
    BitVec &operator<<=(BitVec &&RHS);
    BitVec &operator>>=(BitVec &&RHS);
    BitVec &operator^= (BitVec &&RHS);

    Unit &operator[](const std::size_t &BytePosition) noexcept;
    BitProxy &operator()(const std::size_t &BytePosition, const std::size_t &BitPosition) noexcept;

    Unit &at(const std::size_t &BytePosition);
    BitProxy &at(const std::size_t &BytePosition, const std::size_t &BitPosition);

    // change things to bytePosition and bitposition so that it is more of a 2D array setup
    // how to return a reference poop, I guess need to define a new IntergralTypeProxy?
    template<typename IntegralType>
    IntegralType getBytes(const std::size_t &BytePosition, const std::size_t &BitPosition) const {
        static_assert(std::is_integral_v<IntegralType>, "BitVec: binary data must be passed as a integral data type");
        constexpr uint_fast8_t Bytes = sizeof(IntegralType);
        if constexpr (BitPosition >= UnitBitSize) {
            throw std::invalid_argument("BitVec::getBytes : Bit Position out of bounds, must be less than Unit Bit amount");
        }

        // check to make sure that we dont go out of bounds with IntegralType
    }

    const std::vector<Unit> &getBits(const std::size_t &BitPosition, const std::size_t &OffSet) const;

    template<typename IntegralType>
    IntegralType copyBytes(const std::size_t &BitPosition) const {
        static_assert(std::is_integral_v<IntegralType>, "BitVec: binary data must be passed as a integral data type");
    }
    std::vector<Unit> copyBits(const std::size_t &BitPosition, const std::size_t &Offset) const;

    template<typename IntegralType>
    BitVec &push_back(const IntegralType &Binary, const std::size_t &BitSize) {

        static_assert(std::is_integral_v<IntegralType>, "BitVec: binary data must be passed as a integral data type");
        if constexpr (sizeof(IntegralType) / 8 >= BitSize) {
            throw std::invalid_argument("BitVec: IntegralType Data type must be large enough to hold required Bits");
        }
        
        if(FreeBits) {
            if (BitSize < FreeBits ) {
                DataVec.back() |= (Binary << (FreeBits - BitSize));
                FreeBits = UnitBitSize - ((FreeBits + BitSize) & (UnitBitSize - 1));
                return this; // quick return we are done
            } else {
                DataVec.back() |= (Binary >> (BitSize -= FreeBits));
            }
        }
        std::size_t Units = BitSize / (UnitBitSize / 8);
        std::vector<Unit>::iterator VecIt = nullptr;
        if (FreeBits = calculateFreeBits(BitSize) ) { // this is on purpose
            DataVec.resize(DataVec.size() + Units + 1);
            DataVec.back() = Binary << FreeBits;
            Binary >>= (8 - FreeBits);
            VecIt = DataVec.end() - Units - 1;
        } else {
            DataVec.resize(Units + DataVec.size());
            VecIt = DataVec.end() - Units;
        }

        //TODO: maybe shove into register using simd
        for (size_t i(1); i <= (Units); ++i, ++VecIt) {
            *VecIt = Binary >> ((Units - i) * UnitBitSize);
        }

        return this;
    }

    template<typename IntegralType>
    BitVec &push_back(IntegralType &&Binary, const std::size_t &BitSize) {

        static_assert(std::is_integral_v<IntegralType>, "BitVec::push_back : binary data must be passed as a integral data type");
        if constexpr (sizeof(IntegralType) / 8 >= BitSize) {
            throw std::invalid_argument("BitVec::push_back : IntegralType Data type must be large enough to hold required Bits");
        }
        
        if(FreeBits) {
            if (BitSize < FreeBits ) {
                DataVec.back() |= (Binary << (FreeBits - BitSize));
                FreeBits = UnitBitSize - ((FreeBits + BitSize) & (UnitBitSize - 1));
                return this; // quick return we are done
            } else {
                DataVec.back() |= (Binary >> (BitSize -= FreeBits));
            }
        }
        std::size_t Units = BitSize / (UnitBitSize / 8);
        std::vector<Unit>::iterator VecIt = nullptr;
        if (FreeBits = calculateFreeBits(BitSize) ) { // this is on purpose
            DataVec.resize(DataVec.size() + Units + 1);
            DataVec.back() = Binary << FreeBits;
            Binary >>= (8 - FreeBits);
            VecIt = DataVec.end() - Units - 1;
        } else {
            DataVec.resize(Units + DataVec.size());
            VecIt = DataVec.end() - Units;
        }

        //TODO: maybe shove into register using simd
        for (size_t i(1); i <= (Units); ++i, ++VecIt) {
            *VecIt = Binary >> ((Units - i) * UnitBitSize);
        }

        return this;
    }

    BitVec &push_back(const Unit &FullUnit) noexcept;
    BitVec &push_back(const Unit &&FullUnit) noexcept;

    std::size_t size() const noexcept;

    std::size_t bitCount(const bool &Value) const noexcept;
    // add a find functionality
    
};

#endif